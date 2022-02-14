Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCE74B48AD
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245678AbiBNJ5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:57:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345589AbiBNJ47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:56:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B05A83036;
        Mon, 14 Feb 2022 01:45:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8A4D61237;
        Mon, 14 Feb 2022 09:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0853C340E9;
        Mon, 14 Feb 2022 09:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831940;
        bh=c6PIy4SprYdVh444PBOUULKcNofHrxD6+9VvMSku1TU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0yMobZ+ie1sMnjaXbYNqkhJz//cSyajfhFvfV2Xdxo/qW0qnkxeWx3npptiGzNA7
         JVv5TcIJB4VbOql8x+M0JhZg09dS8VS+H8xh7BPQR4WkcHrCrSS7Oe6UX4oga444gW
         jHcJMMpSs8HYKoPrC+u/vzX5PCC0l/nbxtTniPFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Berger <stefanb@linux.ibm.com>,
        Christian Brauner <brauner@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.15 005/172] ima: Do not print policy rule with inactive LSM labels
Date:   Mon, 14 Feb 2022 10:24:23 +0100
Message-Id: <20220214092506.545330621@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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

From: Stefan Berger <stefanb@linux.ibm.com>

commit 89677197ae709eb1ab3646952c44f6a171c9e74c upstream.

Before printing a policy rule scan for inactive LSM labels in the policy
rule. Inactive LSM labels are identified by args_p != NULL and
rule == NULL.

Fixes: 483ec26eed42 ("ima: ima/lsm policy rule loading logic bug fixes")
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Cc: <stable@vger.kernel.org> # v5.6+
Acked-by: Christian Brauner <brauner@kernel.org>
[zohar@linux.ibm.com: Updated "Fixes" tag]
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_policy.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1852,6 +1852,14 @@ int ima_policy_show(struct seq_file *m,
 
 	rcu_read_lock();
 
+	/* Do not print rules with inactive LSM labels */
+	for (i = 0; i < MAX_LSM_RULES; i++) {
+		if (entry->lsm[i].args_p && !entry->lsm[i].rule) {
+			rcu_read_unlock();
+			return 0;
+		}
+	}
+
 	if (entry->action & MEASURE)
 		seq_puts(m, pt(Opt_measure));
 	if (entry->action & DONT_MEASURE)


