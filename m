Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B279D66C6D1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbjAPQZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233097AbjAPQYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:24:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537862B2BD
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:13:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E403A6102D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036B3C433D2;
        Mon, 16 Jan 2023 16:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885614;
        bh=rujehGlLN2LoRPX4wKaFlXd3wmeUrVXY0ayfJnXbyoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpLwDBhuNAceNru98JIC+v0Up+3MjSTER64xGP3JXQef1v11nBHStORwuyzjZDCz7
         ONNOyjpqZ9vHxWDWVoifZduW0b/rcVOSt3GuYqOdjXy8AgxqvCTPK+9I4Vo/XbCVjo
         ZqaqFc/ag8MXZXpE2iJJkdD+zhCeRwQj/nHrL02E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 118/658] ima: Fix fall-through warnings for Clang
Date:   Mon, 16 Jan 2023 16:43:26 +0100
Message-Id: <20230116154914.894938933@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 28073eb09c5aa29e879490edb88cfd3e7073821e ]

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of just
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Stable-dep-of: c7423dbdbc9e ("ima: Handle -ESTALE returned by ima_filter_rule_match()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_main.c   | 1 +
 security/integrity/ima/ima_policy.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index a768f37a0a4d..ce9d594ddbcd 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -615,6 +615,7 @@ int ima_load_data(enum kernel_load_data_id id)
 			pr_err("impossible to appraise a module without a file descriptor. sig_enforce kernel parameter might help\n");
 			return -EACCES;	/* INTEGRITY_UNKNOWN */
 		}
+		break;
 	default:
 		break;
 	}
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 6cd2f663643c..7f352e85ffad 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -434,6 +434,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 			rc = ima_filter_rule_match(secid, rule->lsm[i].type,
 						   Audit_equal,
 						   rule->lsm[i].rule);
+			break;
 		default:
 			break;
 		}
@@ -666,6 +667,7 @@ void __init ima_init_policy(void)
 		add_rules(default_measurement_rules,
 			  ARRAY_SIZE(default_measurement_rules),
 			  IMA_DEFAULT_POLICY);
+		break;
 	default:
 		break;
 	}
-- 
2.35.1



