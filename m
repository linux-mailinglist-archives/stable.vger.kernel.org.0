Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2244B49B1
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345765AbiBNKSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:18:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347229AbiBNKQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:16:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DA36D94B;
        Mon, 14 Feb 2022 01:53:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 380BF60F31;
        Mon, 14 Feb 2022 09:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C12FC340E9;
        Mon, 14 Feb 2022 09:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832423;
        bh=PoUyA5KKq3J9IjaPm3usTUQS7Ay5dQPs/VrJy+udfcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ovaDAX4/DMv1HnCAO2Dudxy75I6Tj3w98nR3VC9/p1xX5JM7Gp2IN5MiwFMiUQvuU
         SiWNKAnLg3myPlt98ppNfCyMmS1c+OOu05D5dJ4TUCo5O334r7RxREwZTGyOF3UjT2
         9YF3rUs63trMSliFYbKwE7ziPU8MvPHhL9UlNfzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.16 002/203] audit: dont deref the syscall args when checking the openat2 open_how::flags
Date:   Mon, 14 Feb 2022 10:24:06 +0100
Message-Id: <20220214092510.304262461@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Moore <paul@paul-moore.com>

commit 7a82f89de92aac5a244d3735b2bd162c1147620c upstream.

As reported by Jeff, dereferencing the openat2 syscall argument in
audit_match_perm() to obtain the open_how::flags can result in an
oops/page-fault.  This patch fixes this by using the open_how struct
that we store in the audit_context with audit_openat2_how().

Independent of this patch, Richard Guy Briggs posted a similar patch
to the audit mailing list roughly 40 minutes after this patch was
posted.

Cc: stable@vger.kernel.org
Fixes: 1c30e3af8a79 ("audit: add support for the openat2 syscall")
Reported-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/auditsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -185,7 +185,7 @@ static int audit_match_perm(struct audit
 	case AUDITSC_EXECVE:
 		return mask & AUDIT_PERM_EXEC;
 	case AUDITSC_OPENAT2:
-		return mask & ACC_MODE((u32)((struct open_how *)ctx->argv[2])->flags);
+		return mask & ACC_MODE((u32)ctx->openat2.flags);
 	default:
 		return 0;
 	}


