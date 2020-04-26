Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAD01B912B
	for <lists+stable@lfdr.de>; Sun, 26 Apr 2020 17:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgDZPZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 11:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgDZPZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Apr 2020 11:25:39 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CE7C061A0F;
        Sun, 26 Apr 2020 08:25:38 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id e2so11818698eje.13;
        Sun, 26 Apr 2020 08:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T2Cq06nwaYUnQSEJFp1w93cx9fke5QOxLcQLn1TsMv0=;
        b=V/lAfMAiWcZu9RWBhSwKixLdMR0bujLua221UZHUklxd1umdDQeadV4pvKLffcuCpx
         ThcSgXGrmVwJ+LzYQGEKZ8sCXCJRiXqQFWajPQtBC0mjE7QFMlbYohtNx17Xe/6ZDTG/
         83rTbSc1UuYt1OOzv0FF8NUsTfoqSVnlbwwXevE6nt9JcrB3qq+bUieXtypZ/FH9zbph
         zBQce6ZAVHFBwYAu8ZEPNrRZ5fveVaOEH+jCmzxinbn/nQyoE+iTCdEmFXYmPdwFsbn2
         MsgzB+XJhVUFL44kSwZG75okz7WCcTFodadsPJtlCmTye1Qv8rcCgz308v9gzqBWLvl1
         M4WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T2Cq06nwaYUnQSEJFp1w93cx9fke5QOxLcQLn1TsMv0=;
        b=C+e+jAjab/+WRFuGSi32QeDpQufou5SV8TVme6GYEBtV40oaNrjJseqDL66GNkXGZm
         7cAIaluwEEvNhjN3cheWmU6T3tAIxouvUtmv/6x63xp9Daikj9yHVY42veGGKzF/+jQX
         zwlfdO3KcAq3vMTjOzkqFmt6rq7muJ7by2qq1S58p0n8X+ZjzMBhXID/FDj6AzanDkU1
         TgGoTcw1FLKUvwRi1dCMKDIDYJ8KPYCa5nRCDgqRXyyVTQoxCBHlgvtQHBLAyFlGnso+
         vjFJD/xTaWVtL76idgC5mG3zvhv9AYjqR8NyAfreYhwayc4gAzFqf5EAD/N0hsf1t+rz
         wRhw==
X-Gm-Message-State: AGi0PuaFucjmnzwcpVa13REbwN3Fb8d7Xg6kzm4fg063Vq2YLk987kCD
        y8iYKWIfDo0Pv5930rIJraNWZW/1aHWJlaV+wVx6Yw==
X-Google-Smtp-Source: APiQypLCFmVdKZRO9lr5A+/+sWiMjvPv0BPDhJVM3CCytH/FV8E1CE8akCLZgczrO1zJrqo0UKQLkbg289WT2Oj14zM=
X-Received: by 2002:a17:906:2792:: with SMTP id j18mr16279333ejc.215.1587914735845;
 Sun, 26 Apr 2020 08:25:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200424214550.30462-1-olga.kornievskaia@gmail.com> <20200426150342.44DD22078E@mail.kernel.org>
In-Reply-To: <20200426150342.44DD22078E@mail.kernel.org>
From:   Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date:   Sun, 26 Apr 2020 11:25:25 -0400
Message-ID: <CAN-5tyH3wtdy5AtfPJPows5p4zYWiJ2BAD+B-a2R3nqqFxyTVg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] NFSv4.1: fix handling of backchannel binding in BIND_CONN_TO_SESSION
To:     Sasha Levin <sashal@kernel.org>
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        linux-nfs <linux-nfs@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 26, 2020 at 11:03 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.6.7, v5.4.35, v4.19.118, v4.14.177, v4.9.220, v4.4.220.
>
> v5.6.7: Build OK!
> v5.4.35: Failed to apply! Possible dependencies:
>     Unable to calculate
>
> v4.19.118: Failed to apply! Possible dependencies:
>     07d02a67b7fa ("SUNRPC: Simplify lookup code")
>     3453d5708b33 ("NFSv4.1: Avoid false retries when RPC calls are interrupted")
>     5c441544f045 ("NFSv4.x: Handle bad/dead sessions correctly in nfs41_sequence_process()")
>     79b181810285 ("SUNRPC: Convert auth creds to use refcount_t")
>     8276c902bbe9 ("SUNRPC: remove uid and gid from struct auth_cred")
>     95cd623250ad ("SUNRPC: Clean up the AUTH cache code")
>     97f68c6b02e0 ("SUNRPC: add 'struct cred *' to auth_cred and rpc_cred")
>     a52458b48af1 ("NFS/NFSD/SUNRPC: replace generic creds with 'struct cred'.")
>     fc0664fd9bcc ("SUNRPC: remove groupinfo from struct auth_cred.")
>
> v4.14.177: Failed to apply! Possible dependencies:
>     07d02a67b7fa ("SUNRPC: Simplify lookup code")
>     12f275cdd163 ("NFSv4: Retry CLOSE and DELEGRETURN on NFS4ERR_OLD_STATEID.")
>     1eb5d98f16f6 ("nfs: convert to new i_version API")
>     3453d5708b33 ("NFSv4.1: Avoid false retries when RPC calls are interrupted")
>     35156bfff3c0 ("NFSv4: Fix the nfs_inode_set_delegation() arguments")
>     5c441544f045 ("NFSv4.x: Handle bad/dead sessions correctly in nfs41_sequence_process()")
>     79b181810285 ("SUNRPC: Convert auth creds to use refcount_t")
>     95cd623250ad ("SUNRPC: Clean up the AUTH cache code")
>     97f68c6b02e0 ("SUNRPC: add 'struct cred *' to auth_cred and rpc_cred")
>     a52458b48af1 ("NFS/NFSD/SUNRPC: replace generic creds with 'struct cred'.")
>     b3dce6a2f060 ("pnfs/blocklayout: handle transient devices")
>     fc0664fd9bcc ("SUNRPC: remove groupinfo from struct auth_cred.")
>
> v4.9.220: Failed to apply! Possible dependencies:
>     172d9de15a0d ("NFS: Change nfs4_get_session() to take an nfs_client structure")
>     3453d5708b33 ("NFSv4.1: Avoid false retries when RPC calls are interrupted")
>     3be0f80b5fe9 ("NFSv4.1: Fix up replays of interrupted requests")
>     42e1cca7e91e ("NFS: Change nfs4_setup_sequence() to take an nfs_client structure")
>     5c441544f045 ("NFSv4.x: Handle bad/dead sessions correctly in nfs41_sequence_process()")
>     6de7e12f53a1 ("NFS: Use nfs4_setup_sequence() everywhere")
>     7981c8a65914 ("NFS: Create a single nfs4_setup_sequence() function")
>     efc6f4aa742d ("NFS: Move nfs4_get_session() into nfs4_session.h")
>
> v4.4.220: Failed to apply! Possible dependencies:
>     172d9de15a0d ("NFS: Change nfs4_get_session() to take an nfs_client structure")
>     3453d5708b33 ("NFSv4.1: Avoid false retries when RPC calls are interrupted")
>     3be0f80b5fe9 ("NFSv4.1: Fix up replays of interrupted requests")
>     42e1cca7e91e ("NFS: Change nfs4_setup_sequence() to take an nfs_client structure")
>     5c441544f045 ("NFSv4.x: Handle bad/dead sessions correctly in nfs41_sequence_process()")
>     5f83d86cf531 ("NFSv4.x: Fix wraparound issues when validing the callback sequence id")
>     68d264cf02b0 ("NFS42: handle layoutstats stateid error")
>     6de7e12f53a1 ("NFS: Use nfs4_setup_sequence() everywhere")
>     80f9642724af ("NFSv4.x: Enforce the ca_maxresponsesize_cached on the back channel")
>     810d82e68301 ("NFSv4.x: Allow multiple callbacks in flight")
>     9a0fe86745b8 ("pNFS: Handle NFS4ERR_OLD_STATEID correctly in LAYOUTSTAT calls")
>     efc6f4aa742d ("NFS: Move nfs4_get_session() into nfs4_session.h")
>     f74a834a0e1b ("NFSv4.x: CB_SEQUENCE should return NFS4ERR_DELAY if still executing")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

Trond,

This is my first time trying to mark the patch as something that
should be back ported. What's the right approach?

I couldn't find a patch that would make sense to say that this patch
"fixes". Should I just pick one of them (maybe "SUNRPC: Allow creation
of RPC clients with multiple connections" (612b41f808a))?

I should have said that this only needs to be fixed up to when the
feature was included which was 5.3. The fact that I doesn't apply to
5.4 is the only problem I see needs to be looked at / addressed.


>
> --
> Thanks
> Sasha
