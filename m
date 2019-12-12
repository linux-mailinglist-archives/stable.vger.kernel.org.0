Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFC011CB56
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 11:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbfLLKy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 05:54:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728458AbfLLKy1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 05:54:27 -0500
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49A682077B
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 10:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576148066;
        bh=xfT3oa1uEBNpGWlpMXm+YjRMIj4uMCSNP+ldAU1Dc/0=;
        h=From:Date:Subject:To:Cc:From;
        b=SvPZ5j3lvFiwji0uAinxITm78pu9GqKDSKbDZQtLlz//peh4vMq+31oOyvNWwMMN5
         tnpVOB3QkSdUIehnIknZGjNEQmMq8jCitKkXOocUKYiq+/RDGWojMTHXTSV+Q6/qla
         RTmz7kOewHj0Lnhd81H3aoA5iXufTLnK9vrBnj5g=
Received: by mail-wr1-f45.google.com with SMTP id c14so2208980wrn.7
        for <stable@vger.kernel.org>; Thu, 12 Dec 2019 02:54:26 -0800 (PST)
X-Gm-Message-State: APjAAAVPGaUv//9MJ5VF9kUv0723Jegq8ABWFIRv/Z2SoFzK7HUH1fbx
        0vtMjo+MfqPNofp+JongLUvAdGxmiPSKJJDwEsI=
X-Google-Smtp-Source: APXvYqyCwHba5I1K4Bo7sTveKYirS68oYPYbTn+B+NuqnN0vGJVxzO7/qRouFomPLJD2HnCHBibLE9/+rINizt4ewxU=
X-Received: by 2002:a05:6000:11c6:: with SMTP id i6mr5688734wrx.178.1576148064756;
 Thu, 12 Dec 2019 02:54:24 -0800 (PST)
MIME-Version: 1.0
From:   Chen-Yu Tsai <wens@kernel.org>
Date:   Thu, 12 Dec 2019 18:54:12 +0800
X-Gmail-Original-Message-ID: <CAGb2v656iHP+6X12gT+Kfc3BkM2w=rU6yfHTk03JgaXrUy02TA@mail.gmail.com>
Message-ID: <CAGb2v656iHP+6X12gT+Kfc3BkM2w=rU6yfHTk03JgaXrUy02TA@mail.gmail.com>
Subject: Regression from "mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy()"
 in stable kernels
To:     Joerg Roedel <jroedel@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, Pavel Machek <pavel@denx.de>,
        Chen-Yu Tsai <wens@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I'd like to report a very severe performance regression due to

    mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy() in stable kernels

in v4.19.88. I believe this was included since v4.19.67. It is also
in all the other LTS kernels, except 3.16.

So today I switched an x86_64 production server from v5.1.21 to
v4.19.88, because we kept hitting runaway kcompactd and kswapd.
Plus there was a significant increase in memory usage compared to
v5.1.5. I'm still bisecting that on another production server.

The service we run is one of the largest forums in Taiwan [1].
It is a terminal-based bulletin board system running over telnet,
SSH or a custom WebSocket bridge. The service itself is the
one-process-per-user type of design from the old days. This
means a lot of forks when there are user spikes or reconnections.

(Reconnections happen because a lot of people use mobile apps that
 wrap the service, but they get disconnected as soon as they are
 backgrounded.)

With v4.19.88 we saw a lot of contention on pgd_lock in the process
fork path with CONFIG_VMAP_STACK=y:

Samples: 937K of event 'cycles:ppp', Event count (approx.): 499112453614
  Children      Self  Command          Shared Object                 Symbol
+   31.15%     0.03%  mbbsd            [kernel.kallsyms]
[k] entry_SYSCALL_64_after_hwframe
+   31.12%     0.02%  mbbsd            [kernel.kallsyms]
[k] do_syscall_64
+   28.12%     0.42%  mbbsd            [kernel.kallsyms]
[k] do_raw_spin_lock
-   27.70%    27.62%  mbbsd            [kernel.kallsyms]
[k] queued_spin_lock_slowpath
   - 18.73% __libc_fork
      - 18.33% entry_SYSCALL_64_after_hwframe
           do_syscall_64
         - _do_fork
            - 18.33% copy_process.part.64
               - 11.00% __vmalloc_node_range
                  - 10.93% sync_global_pgds_l4
                       do_raw_spin_lock
                       queued_spin_lock_slowpath
               - 7.27% mm_init.isra.59
                    pgd_alloc
                    do_raw_spin_lock
                    queued_spin_lock_slowpath
   - 8.68% 0x41fd89415541f689
      - __libc_start_main
         + 7.49% main
         + 0.90% main

This hit us pretty hard, with the service dropping below one-third
of its original capacity.

With CONFIG_VMAP_STACK=n, the fork code path skips this, but other
vmalloc users are still affected. One other area is the tty layer.
This also causes problems for us since there can be as many as 15k
users over SSH, some coming and going. So we got a lot of hung sshd
processes as well. Unfortunately I don't have any perf reports or
kernel logs to go with.

Now I understand that there is already a fix in -next:

    https://lore.kernel.org/patchwork/patch/1137341/

However the code has changed a lot in mainline and I'm not sure how
to backport this. For now I just reverted the commit by hand by
removing the offending code. Seems to work OK, and based on the commit
logs I guess it's safe to do so, as we're not running X86-32 or PTI.


Regards
ChenYu

[1] https://en.wikipedia.org/wiki/PTT_Bulletin_Board_System
