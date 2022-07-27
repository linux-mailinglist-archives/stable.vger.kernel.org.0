Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67CD582FE9
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242249AbiG0Rad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242385AbiG0R3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:29:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0284952DF1;
        Wed, 27 Jul 2022 09:47:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BB6AB821D2;
        Wed, 27 Jul 2022 16:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D755CC433C1;
        Wed, 27 Jul 2022 16:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940463;
        bh=m+MdzK3zbrk88iLvCTtfSb2ljfBx9asE8hnGNYWG9Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JK6MAeOhwkgIY0tOMHTLZBQlj1PRjnwgK2ViqiarigWGi6tcxuukdRYbo+TNobeq
         aUkaW43FryG7esEp2sKFCel0ltigDeO74GEDJeMHgtSAj7uoGLerALcph7y+j9O7GD
         HSypBxcT2lognDBFNip7E9ytmJh7icNhqb2eTmos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Snowberg <eric.snowberg@oracle.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        John Haxby <john.haxby@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.18 005/158] lockdown: Fix kexec lockdown bypass with ima policy
Date:   Wed, 27 Jul 2022 18:11:09 +0200
Message-Id: <20220727161021.663655785@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Snowberg <eric.snowberg@oracle.com>

commit 543ce63b664e2c2f9533d089a4664b559c3e6b5b upstream.

The lockdown LSM is primarily used in conjunction with UEFI Secure Boot.
This LSM may also be used on machines without UEFI.  It can also be
enabled when UEFI Secure Boot is disabled.  One of lockdown's features
is to prevent kexec from loading untrusted kernels.  Lockdown can be
enabled through a bootparam or after the kernel has booted through
securityfs.

If IMA appraisal is used with the "ima_appraise=log" boot param,
lockdown can be defeated with kexec on any machine when Secure Boot is
disabled or unavailable.  IMA prevents setting "ima_appraise=log" from
the boot param when Secure Boot is enabled, but this does not cover
cases where lockdown is used without Secure Boot.

To defeat lockdown, boot without Secure Boot and add ima_appraise=log to
the kernel command line; then:

  $ echo "integrity" > /sys/kernel/security/lockdown
  $ echo "appraise func=KEXEC_KERNEL_CHECK appraise_type=imasig" > \
    /sys/kernel/security/ima/policy
  $ kexec -ls unsigned-kernel

Add a call to verify ima appraisal is set to "enforce" whenever lockdown
is enabled.  This fixes CVE-2022-21505.

Cc: stable@vger.kernel.org
Fixes: 29d3c1c8dfe7 ("kexec: Allow kexec_file() with appropriate IMA policy when locked down")
Signed-off-by: Eric Snowberg <eric.snowberg@oracle.com>
Acked-by: Mimi Zohar <zohar@linux.ibm.com>
Reviewed-by: John Haxby <john.haxby@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_policy.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -2181,6 +2181,10 @@ bool ima_appraise_signature(enum kernel_
 	if (id >= READING_MAX_ID)
 		return false;
 
+	if (id == READING_KEXEC_IMAGE && !(ima_appraise & IMA_APPRAISE_ENFORCE)
+	    && security_locked_down(LOCKDOWN_KEXEC))
+		return false;
+
 	func = read_idmap[id] ?: FILE_CHECK;
 
 	rcu_read_lock();


