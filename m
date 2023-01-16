Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6E866C49E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjAPP4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbjAPP4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:56:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B286223111
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:56:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E5BA61030
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BC4C433D2;
        Mon, 16 Jan 2023 15:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884581;
        bh=25mIPByvC0F11M+OqIPwMmaMS3HV65Ilw4mgKFVl9UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5bgCCqOnaB/4aUAFyYcYQpe8iJUo7tAk1/gqMKjQlV2C/HzSs/ZnPAEdG2Ak06EJ
         WPGVYjpus5HMqAQArXnMSfVUNY9Xj9x9ZW9frm7fd1lKnubZKRNTkpECp3nSexBf7Q
         qJ7qsgdY0Fwzzw7rtK8xlK8p7TWI7arShKIifmos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Brown <broonie@kernel.org>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 6.1 060/183] arm64/signal: Always accept SVE signal frames on SME only systems
Date:   Mon, 16 Jan 2023 16:49:43 +0100
Message-Id: <20230116154805.876815145@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Mark Brown <broonie@kernel.org>

commit 7dde62f0687c8856b6c0660066c7ee83a6a6f033 upstream.

Currently we reject an attempt to restore a SVE signal frame on a system
with SME but not SVE supported. This means that it is not possible to
disable streaming mode via signal return as this is configured via the
flags in the SVE signal context. Instead accept the signal frame, we will
require it to have a vector length of 0 specified and no payload since the
task will have no SVE vector length configured.

Fixes: 85ed24dad290 ("arm64/sme: Implement streaming SVE signal handling")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20221223-arm64-fix-sme-only-v1-2-938d663f69e5@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/signal.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -280,7 +280,12 @@ static int restore_sve_fpsimd_context(st
 
 		vl = task_get_sme_vl(current);
 	} else {
-		if (!system_supports_sve())
+		/*
+		 * A SME only system use SVE for streaming mode so can
+		 * have a SVE formatted context with a zero VL and no
+		 * payload data.
+		 */
+		if (!system_supports_sve() && !system_supports_sme())
 			return -EINVAL;
 
 		vl = task_get_sve_vl(current);


