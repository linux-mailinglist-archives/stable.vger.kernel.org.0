Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C76A4B47AB
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245050AbiBNJrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:47:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245111AbiBNJpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:45:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBD160D96;
        Mon, 14 Feb 2022 01:38:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FEBD6118F;
        Mon, 14 Feb 2022 09:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37491C340EF;
        Mon, 14 Feb 2022 09:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831519;
        bh=0SNWPaXymZm3bX46jRXr1RWWCMk24h+5vqzYav0VjV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juo4RSE8Fugx8Vv2djVsATPlXRL0kWfbS+bQ8X42Es8fxPpXrwTHLGEHzYhpO3Yz3
         /z/HYZpWXjIlGr+Mlm43WoLIjk3ZyioSUDG4/OZdT/pUx+2tRZNu2R6yriC0zvQSUW
         JfZijHqLghTz83arXi7zaXNK9upKpqk/elvNSOXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoke Wang <xkernel.wang@foxmail.com>,
        Paul Moore <paul@paul-moore.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.10 001/116] integrity: check the return value of audit_log_start()
Date:   Mon, 14 Feb 2022 10:25:00 +0100
Message-Id: <20220214092458.722049185@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

From: Xiaoke Wang <xkernel.wang@foxmail.com>

commit 83230351c523b04ff8a029a4bdf97d881ecb96fc upstream.

audit_log_start() returns audit_buffer pointer on success or NULL on
error, so it is better to check the return value of it.

Fixes: 3323eec921ef ("integrity: IMA as an integrity service provider")
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/integrity_audit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -45,6 +45,8 @@ void integrity_audit_message(int audit_m
 		return;
 
 	ab = audit_log_start(audit_context(), GFP_KERNEL, audit_msgno);
+	if (!ab)
+		return;
 	audit_log_format(ab, "pid=%d uid=%u auid=%u ses=%u",
 			 task_pid_nr(current),
 			 from_kuid(&init_user_ns, current_uid()),


