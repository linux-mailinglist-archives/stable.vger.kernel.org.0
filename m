Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E544A7479
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 16:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiBBPTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 10:19:55 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41742 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiBBPTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 10:19:54 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:60426)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nFHQH-007mjU-5V; Wed, 02 Feb 2022 08:19:53 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:54972 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nFHQF-004Ovl-OG; Wed, 02 Feb 2022 08:19:52 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Jann Horn <jannh@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Bill Messmer <wmessmer@microsoft.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
References: <20220126025739.2014888-1-jannh@google.com>
Date:   Wed, 02 Feb 2022 09:19:45 -0600
In-Reply-To: <20220126025739.2014888-1-jannh@google.com> (Jann Horn's message
        of "Wed, 26 Jan 2022 03:57:39 +0100")
Message-ID: <87czk5l2i6.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nFHQF-004Ovl-OG;;;mid=<87czk5l2i6.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19nRtuaon4QkvFcsJ9kI9dJDIYxKnHkUs4=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_SCC_BODY_TEXT_LINE,T_TM2_M_HEADER_IN_MSG,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jann Horn <jannh@google.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 801 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 11 (1.4%), b_tie_ro: 10 (1.2%), parse: 1.38
        (0.2%), extract_message_metadata: 4.7 (0.6%), get_uri_detail_list:
        1.98 (0.2%), tests_pri_-1000: 6 (0.7%), tests_pri_-950: 1.85 (0.2%),
        tests_pri_-900: 1.50 (0.2%), tests_pri_-90: 439 (54.8%), check_bayes:
        437 (54.6%), b_tokenize: 11 (1.4%), b_tok_get_all: 9 (1.2%),
        b_comp_prob: 3.8 (0.5%), b_tok_touch_all: 409 (51.1%), b_finish: 0.96
        (0.1%), tests_pri_0: 308 (38.4%), check_dkim_signature: 0.46 (0.1%),
        check_dkim_adsp: 3.0 (0.4%), poll_dns_idle: 1.16 (0.1%), tests_pri_10:
        3.1 (0.4%), tests_pri_500: 11 (1.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] coredump: Also dump first pages of non-executable ELF
 libraries
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jann Horn <jannh@google.com> writes:

> When I rewrote the VMA dumping logic for coredumps, I changed it to
> recognize ELF library mappings based on the file being executable instead
> of the mapping having an ELF header. But turns out, distros ship many ELF
> libraries as non-executable, so the heuristic goes wrong...
>
> Restore the old behavior where FILTER(ELF_HEADERS) dumps the first page of
> any offset-0 readable mapping that starts with the ELF magic.
>
> This fix is technically layer-breaking a bit, because it checks for
> something ELF-specific in fs/coredump.c; but since we probably want to
> share this between standard ELF and FDPIC ELF anyway, I guess it's fine?
> And this also keeps the change small for backporting.

In light of the conflict with my other changes, and in light of the pain
of calling get_user.

Is there any reason why the doesn't unconditionally dump all headers?
Something like the diff below?

I looked in the history and the code was filtering for ELF headers
there already.  I am just thinking this feels like a good idea
regardless of the file format to help verify the file on-disk
is the file we think was mapped.

Eric

diff --git a/fs/coredump.c b/fs/coredump.c
index 6a97a8ea7295..ef3b03e4cf59 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1047,8 +1047,7 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
         * dump the first page to aid in determining what was mapped here.
         */
        if (FILTER(ELF_HEADERS) &&
-           vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ) &&
-           (READ_ONCE(file_inode(vma->vm_file)->i_mode) & 0111) != 0)
+           vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ))
                return PAGE_SIZE;
 
 #undef FILTER


