Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76569B14C7
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 21:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfILTZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 15:25:14 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:45340 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfILTZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Sep 2019 15:25:14 -0400
Received: by mail-pl1-f179.google.com with SMTP id x3so12179017plr.12
        for <stable@vger.kernel.org>; Thu, 12 Sep 2019 12:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=215gmd/2NvhCAflz9duy5bycIfSe5W0CTllkHmIpIAQ=;
        b=URjflnQebwmG3WC/6FWqASb956MiMkDvGpUUrlGuxSoIetW0iFH5wkKST+k1P1m0Ls
         jwflj1U5SrQqJFuyMIu15KL8ck7LXWwJS6G33ORBPhHGyCr+FBBeGb2E1hU9urGBo3jC
         sjHezLmPgMwRO4vRmVDNHtTT1Dwp04T09UnJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=215gmd/2NvhCAflz9duy5bycIfSe5W0CTllkHmIpIAQ=;
        b=JQQFWfaRdcgKJ2t5KzmX5eN+vtt7Pdv8unXCphdh+5k2Woy6iTWJmjhn+SBbHlOebD
         HVcQSiuuRq37nwG0kzvU5LDtDupWvaBtPy0X0HtXVPdhh0o5EIZR4QwaWhhdCBiV0KaQ
         ux7apIXPXHeLuHlqGFxYyWW8NxRn2/GTJwsUGvWkrUica1MQSQ0qfkvlD5gk67oWqAN4
         Ns3cO0pz/ypvtsh4KX8y855XIdk18UHTo6cFRxp/I2IW78OtpxG3jtfa6hfTo8d9I+98
         WDvs0QggllpRoLj5t1ZfOzbpfAXaZ+ZurJw++keZ7rIZSPqF2v0yslWOuZi109TdvS+R
         bXDw==
X-Gm-Message-State: APjAAAWC5x8542WrsiTecHCoh76Kv3e4Z+k44L9o7HalEtO66eOPUQK+
        rHh518H4hFCquPsWnzNSNRmFvah7o4Kb7A==
X-Google-Smtp-Source: APXvYqwP40zZ/ZUknPM0LAtw3IJ6NiHZNE0tG1GJj0gJYp00rWOr+fCRc4s6sxj5nF3szxmwGb/kVQ==
X-Received: by 2002:a17:902:8690:: with SMTP id g16mr46110916plo.282.1568316313413;
        Thu, 12 Sep 2019 12:25:13 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id e6sm51142017pfl.146.2019.09.12.12.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 12:25:12 -0700 (PDT)
Date:   Thu, 12 Sep 2019 12:25:10 -0700
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        davej@codemonkey.org.uk, daniel@iogearbox.net
Subject: 6ae81ced3788 ("af_packet: tone down the Tx-ring unsupported spew.")
Message-ID: <20190912192508.GA106326@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Syzkaller has triggered a WARNING in packet_set_ring when fuzzing a 4.4 kernel with the following stacktrace.
Call Trace:
  __dump_stack lib/dump_stack.c:15 [inline]
  dump_stack+0xc1/0x124 lib/dump_stack.c:51
  panic+0x1a7/0x351 kernel/panic.c:115
  warn_slowpath_common+0x12a/0x140 kernel/panic.c:463
  warn_slowpath_fmt+0xb0/0xe0 kernel/panic.c:479
  packet_set_ring+0x13ed/0x19c0 net/packet/af_packet.c:4104
  packet_setsockopt+0x53e/0x21d0 net/packet/af_packet.c:3578
  SYSC_setsockopt net/socket.c:1766 [inline]
  SyS_setsockopt+0x15d/0x240 net/socket.c:1745
  entry_SYSCALL_64_fastpath+0x12/0x72


Could the following patch be applied in v4.4.y? It is present in v4.9.y. Applying this patch could
allow the fuzzer to explore more codepaths.
* 6ae81ced3788 ("af_packet: tone down the Tx-ring unsupported spew.")


Thanks,
- Zubin
