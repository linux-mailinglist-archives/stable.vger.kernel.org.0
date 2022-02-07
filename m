Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC084ABB91
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381875AbiBGL3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382976AbiBGLVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:21:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33A3C0401E3;
        Mon,  7 Feb 2022 03:20:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E17EB811BC;
        Mon,  7 Feb 2022 11:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D728C004E1;
        Mon,  7 Feb 2022 11:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232843;
        bh=ibDfKO43ua73Gx9a9As84eX2A+Zft8z5jC5qig7O/0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BW6MKdl/B1jRUdwt21HONEZAl2mqoWsMtJw8f52TKnPh1zgkqvbac18m3u/m3Y9X1
         97Sf428lfsK2mDxwNVMQnQ932qoZVSmUmnYmslc8u0Ag2y9Ay/u59d3DpCdUuVv657
         q0d9T4DRjOTrfLj+a4MKOah0pp6uXAuh1N57j2eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vratislav Bendel <vbendel@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 01/74] selinux: fix double free of cond_list on error paths
Date:   Mon,  7 Feb 2022 12:05:59 +0100
Message-Id: <20220207103757.281148498@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vratislav Bendel <vbendel@redhat.com>

commit 186edf7e368c40d06cf727a1ad14698ea67b74ad upstream.

On error path from cond_read_list() and duplicate_policydb_cond_list()
the cond_list_destroy() gets called a second time in caller functions,
resulting in NULL pointer deref.  Fix this by resetting the
cond_list_len to 0 in cond_list_destroy(), making subsequent calls a
noop.

Also consistently reset the cond_list pointer to NULL after freeing.

Cc: stable@vger.kernel.org
Signed-off-by: Vratislav Bendel <vbendel@redhat.com>
[PM: fix line lengths in the description]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/conditional.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -152,6 +152,8 @@ static void cond_list_destroy(struct pol
 	for (i = 0; i < p->cond_list_len; i++)
 		cond_node_destroy(&p->cond_list[i]);
 	kfree(p->cond_list);
+	p->cond_list = NULL;
+	p->cond_list_len = 0;
 }
 
 void cond_policydb_destroy(struct policydb *p)
@@ -440,7 +442,6 @@ int cond_read_list(struct policydb *p, v
 	return 0;
 err:
 	cond_list_destroy(p);
-	p->cond_list = NULL;
 	return rc;
 }
 


