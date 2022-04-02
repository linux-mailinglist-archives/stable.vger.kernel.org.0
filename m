Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C45F4F0010
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 11:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238482AbiDBJWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 05:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiDBJWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 05:22:44 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F37A1B3F58;
        Sat,  2 Apr 2022 02:20:49 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id l36so1524855ybj.12;
        Sat, 02 Apr 2022 02:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IJY9U4i1nkvvaH8yUan2pSMhO1qrTzL8+jF4ya30L9o=;
        b=UBcAtrcJtRl7TWAz6DMcK5nVOpq6y1Zf5C77V8QYtDpaswK8E84hZiaiNPVczOmYRX
         rQekxXYp93nxFDgyE8tSn4J0NwaCAmBuydFOLmJ/2xRNuAAJtwz97BWMUxxqdsGbuP3R
         qR9E2nJ0Y608vZKdGv1IG4KtqOjaef6Q1bTlR553oCtGkuCFm2PoZx4xqinQn8VQnFeA
         W/PIn3ppp034wWmlSNuAruwoJR7p7sWwC95L/RooKKvlD/KtjwAJBQMT3/57F9dvTlV8
         hYChNCFeQF/VzhwzyETAhc1HEUUyBwDQaw7fdqT1Cgh/yzCXSfUkyjowH5tabrlfodzq
         MVxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IJY9U4i1nkvvaH8yUan2pSMhO1qrTzL8+jF4ya30L9o=;
        b=vgX1w4FmHCLuQdpA3db7hmSzIeHQKuNrDFxnv8crtXmULkfWCb/2PybHW3ZNYU0BzW
         0v+t1tC+Lygl480xVuIdZtWsFkVqbhBiWdXMj6zKMgc6J8j2KelK1BYFV67dDqqWBvHH
         L30av+BQ1bfUkH/EKbJNshtXAmAQ9pLR0MD1nREWyAem4PPJb2YYWG9puLqmZYE0W86u
         APYfVRQOwgS/dbrpkdrdZe7P1Xiy9UdYiOhM+/OmQMR0g4+kwg3XlHaiZtwISKz3bSlN
         Vjm1ot1qoRT/7qYU8QjiTBn/6daZ2biPwBFnqUA/xKDhB8igg6ASIaaX34yuJ1Mw62IN
         Tm8g==
X-Gm-Message-State: AOAM531NEfcEE8638ceVRdmG+HasjWLC2RjelOrruEdU/l6YP/at9me7
        0r7p6UZy7vwEGBE/K8AwMwlOma2KseiA/dF/4mAokDug
X-Google-Smtp-Source: ABdhPJwbHXu8sGwGGGj2Ns+DZQyvBxl5BOWoIaxMPQwYEh+NnkmyPlcJdUFSSPSo9Pd1dSBcT5gBF26HnixiZz9V2No=
X-Received: by 2002:a25:23c6:0:b0:63d:5d45:680f with SMTP id
 j189-20020a2523c6000000b0063d5d45680fmr6306246ybj.469.1648891248595; Sat, 02
 Apr 2022 02:20:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220329192006.16750-1-pc@cjr.nz>
In-Reply-To: <20220329192006.16750-1-pc@cjr.nz>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sat, 2 Apr 2022 19:20:37 +1000
Message-ID: <CAN05THT=dRBuhP0+Les9U-jd8L+-xJaQbxJE=dvHQhvBBqprWg@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: prevent bad output lengths in smb2_ioctl_query_info()
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by me for both patches

On Thu, Mar 31, 2022 at 12:58 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> When calling smb2_ioctl_query_info() with
> smb_query_info::flags=PASSTHRU_FSCTL and
> smb_query_info::output_buffer_length=0, the following would return
> 0x10
>
>         buffer = memdup_user(arg + sizeof(struct smb_query_info),
>                              qi.output_buffer_length);
>         if (IS_ERR(buffer)) {
>                 kfree(vars);
>                 return PTR_ERR(buffer);
>         }
>
> rather than a valid pointer thus making IS_ERR() check fail.  This
> would then cause a NULL ptr deference in @buffer when accessing it
> later in smb2_ioctl_query_ioctl().  While at it, prevent having a
> @buffer smaller than 8 bytes to correctly handle SMB2_SET_INFO
> FileEndOfFileInformation requests when
> smb_query_info::flags=PASSTHRU_SET_INFO.
>
> Here is a small C reproducer which triggers a NULL ptr in @buffer when
> passing an invalid smb_query_info::flags
>
>         #include <stdio.h>
>         #include <stdlib.h>
>         #include <stdint.h>
>         #include <unistd.h>
>         #include <fcntl.h>
>         #include <sys/ioctl.h>
>
>         #define die(s) perror(s), exit(1)
>         #define QUERY_INFO 0xc018cf07
>
>         int main(int argc, char *argv[])
>         {
>                 int fd;
>
>                 if (argc < 2)
>                         exit(1);
>                 fd = open(argv[1], O_RDONLY);
>                 if (fd == -1)
>                         die("open");
>                 if (ioctl(fd, QUERY_INFO, (uint32_t[]) { 0, 0, 0, 4, 0, 0}) == -1)
>                         die("ioctl");
>                 close(fd);
>                 return 0;
>         }
>
>         mount.cifs //srv/share /mnt -o ...
>         gcc repro.c && ./a.out /mnt/f0
>
>         [  114.138620] general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN NOPTI
>         [  114.139310] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>         [  114.139775] CPU: 2 PID: 995 Comm: a.out Not tainted 5.17.0-rc8 #1
>         [  114.140148] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.15.0-0-g2dd4b9b-rebuilt.opensuse.org 04/01/2014
>         [  114.140818] RIP: 0010:smb2_ioctl_query_info+0x206/0x410 [cifs]
>         [  114.141221] Code: 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 c8 01 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b 7b 28 4c 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 9c 01 00 00 49 8b 3f e8 58 02 fb ff 48 8b 14 24
>         [  114.142348] RSP: 0018:ffffc90000b47b00 EFLAGS: 00010256
>         [  114.142692] RAX: dffffc0000000000 RBX: ffff888115503200 RCX: ffffffffa020580d
>         [  114.143119] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffffffa043a380
>         [  114.143544] RBP: ffff888115503278 R08: 0000000000000001 R09: 0000000000000003
>         [  114.143983] R10: fffffbfff4087470 R11: 0000000000000001 R12: ffff888115503288
>         [  114.144424] R13: 00000000ffffffea R14: ffff888115503228 R15: 0000000000000000
>         [  114.144852] FS:  00007f7aeabdf740(0000) GS:ffff888151600000(0000) knlGS:0000000000000000
>         [  114.145338] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>         [  114.145692] CR2: 00007f7aeacfdf5e CR3: 000000012000e000 CR4: 0000000000350ee0
>         [  114.146131] Call Trace:
>         [  114.146291]  <TASK>
>         [  114.146432]  ? smb2_query_reparse_tag+0x890/0x890 [cifs]
>         [  114.146800]  ? cifs_mapchar+0x460/0x460 [cifs]
>         [  114.147121]  ? rcu_read_lock_sched_held+0x3f/0x70
>         [  114.147412]  ? cifs_strndup_to_utf16+0x15b/0x250 [cifs]
>         [  114.147775]  ? dentry_path_raw+0xa6/0xf0
>         [  114.148024]  ? cifs_convert_path_to_utf16+0x198/0x220 [cifs]
>         [  114.148413]  ? smb2_check_message+0x1080/0x1080 [cifs]
>         [  114.148766]  ? rcu_read_lock_sched_held+0x3f/0x70
>         [  114.149065]  cifs_ioctl+0x1577/0x3320 [cifs]
>         [  114.149371]  ? lock_downgrade+0x6f0/0x6f0
>         [  114.149631]  ? cifs_readdir+0x2e60/0x2e60 [cifs]
>         [  114.149956]  ? rcu_read_lock_sched_held+0x3f/0x70
>         [  114.150250]  ? __rseq_handle_notify_resume+0x80b/0xbe0
>         [  114.150562]  ? __up_read+0x192/0x710
>         [  114.150791]  ? __ia32_sys_rseq+0xf0/0xf0
>         [  114.151025]  ? __x64_sys_openat+0x11f/0x1d0
>         [  114.151296]  __x64_sys_ioctl+0x127/0x190
>         [  114.151549]  do_syscall_64+0x3b/0x90
>         [  114.151768]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>         [  114.152079] RIP: 0033:0x7f7aead043df
>         [  114.152306] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <41> 89 c0 3d 00 f0 ff ff 77 1f 48 8b 44 24 18 64 48 2b 04 25 28 00
>         [  114.153431] RSP: 002b:00007ffc2e0c1f80 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>         [  114.153890] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7aead043df
>         [  114.154315] RDX: 00007ffc2e0c1ff0 RSI: 00000000c018cf07 RDI: 0000000000000003
>         [  114.154747] RBP: 00007ffc2e0c2010 R08: 00007f7aeae03db0 R09: 00007f7aeae24c4e
>         [  114.155192] R10: 00007f7aeabf7d40 R11: 0000000000000246 R12: 00007ffc2e0c2128
>         [  114.155642] R13: 0000000000401176 R14: 0000000000403df8 R15: 00007f7aeae57000
>         [  114.156071]  </TASK>
>         [  114.156218] Modules linked in: cifs cifs_arc4 cifs_md4 bpf_preload
>         [  114.156608] ---[ end trace 0000000000000000 ]---
>         [  114.156898] RIP: 0010:smb2_ioctl_query_info+0x206/0x410 [cifs]
>         [  114.157792] Code: 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 c8 01 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b 7b 28 4c 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 9c 01 00 00 49 8b 3f e8 58 02 fb ff 48 8b 14 24
>         [  114.159293] RSP: 0018:ffffc90000b47b00 EFLAGS: 00010256
>         [  114.159641] RAX: dffffc0000000000 RBX: ffff888115503200 RCX: ffffffffa020580d
>         [  114.160093] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffffffa043a380
>         [  114.160699] RBP: ffff888115503278 R08: 0000000000000001 R09: 0000000000000003
>         [  114.161196] R10: fffffbfff4087470 R11: 0000000000000001 R12: ffff888115503288
>         [  114.155642] R13: 0000000000401176 R14: 0000000000403df8 R15: 00007f7aeae57000
>         [  114.156071]  </TASK>
>         [  114.156218] Modules linked in: cifs cifs_arc4 cifs_md4 bpf_preload
>         [  114.156608] ---[ end trace 0000000000000000 ]---
>         [  114.156898] RIP: 0010:smb2_ioctl_query_info+0x206/0x410 [cifs]
>         [  114.157792] Code: 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 c8 01 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b 7b 28 4c 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 9c 01 00 00 49 8b 3f e8 58 02 fb ff 48 8b 14 24
>         [  114.159293] RSP: 0018:ffffc90000b47b00 EFLAGS: 00010256
>         [  114.159641] RAX: dffffc0000000000 RBX: ffff888115503200 RCX: ffffffffa020580d
>         [  114.160093] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffffffa043a380
>         [  114.160699] RBP: ffff888115503278 R08: 0000000000000001 R09: 0000000000000003
>         [  114.161196] R10: fffffbfff4087470 R11: 0000000000000001 R12: ffff888115503288
>         [  114.161823] R13: 00000000ffffffea R14: ffff888115503228 R15: 0000000000000000
>         [  114.162274] FS:  00007f7aeabdf740(0000) GS:ffff888151600000(0000) knlGS:0000000000000000
>         [  114.162853] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>         [  114.163218] CR2: 00007f7aeacfdf5e CR3: 000000012000e000 CR4: 0000000000350ee0
>         [  114.163691] Kernel panic - not syncing: Fatal exception
>         [  114.164087] Kernel Offset: disabled
>         [  114.164316] ---[ end Kernel panic - not syncing: Fatal exception ]---
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/smb2ops.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index bf5d5b5ea829..600a5be3ccd0 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1662,11 +1662,12 @@ smb2_ioctl_query_info(const unsigned int xid,
>         if (smb3_encryption_required(tcon))
>                 flags |= CIFS_TRANSFORM_REQ;
>
> -       buffer = memdup_user(arg + sizeof(struct smb_query_info),
> -                            qi.output_buffer_length);
> -       if (IS_ERR(buffer)) {
> -               kfree(vars);
> -               return PTR_ERR(buffer);
> +       if (qi.output_buffer_length) {
> +               buffer = memdup_user(arg + sizeof(struct smb_query_info), qi.output_buffer_length);
> +               if (IS_ERR(buffer)) {
> +                       kfree(vars);
> +                       return PTR_ERR(buffer);
> +               }
>         }
>
>         /* Open */
> @@ -1729,10 +1730,13 @@ smb2_ioctl_query_info(const unsigned int xid,
>                 /* Can eventually relax perm check since server enforces too */
>                 if (!capable(CAP_SYS_ADMIN))
>                         rc = -EPERM;
> -               else  {
> +               else if (qi.output_buffer_length < 8)
> +                       rc = -EINVAL;
> +               else {
>                         rqst[1].rq_iov = &vars->si_iov[0];
>                         rqst[1].rq_nvec = 1;
>
> +                       /* MS-FSCC 2.4.13 FileEndOfFileInformation */
>                         size[0] = 8;
>                         data[0] = buffer;
>
> --
> 2.35.1
>
