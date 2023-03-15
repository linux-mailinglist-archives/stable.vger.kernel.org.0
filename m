Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEA56BB01B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbjCOMP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjCOMPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:15:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29FF7EA29
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:15:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9599AB81DFD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE00C433D2;
        Wed, 15 Mar 2023 12:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882514;
        bh=IFhJB+sf7MKOEKbEeQFfRuQfBD0CB5SBohMJj+mx0Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOnMnjSfw1fkBTraMWbEVOYzHRgCqXyKFAI+HWUsusBv9JNWOL4rHayvm6/dAPRaJ
         YI/FESt9443vVCJym018O3kjLq3c0iZ68MeMvTSNekfMJhEw/GiLNxyt4bxycV+dIN
         a1kNgLo1xemYrC1h5RAxcdFhI8aHo0SPWAcYhAjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, tglx@linutronix.de
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Rhythm Mahajan <rhythm.m.mahajan@oracle.com>
Subject: [PATCH 4.14 21/21] x86/cpu: Fix LFENCE serialization check in init_amd()
Date:   Wed, 15 Mar 2023 13:12:44 +0100
Message-Id: <20230315115719.623088937@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115718.796692048@linuxfoundation.org>
References: <20230315115718.796692048@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rhythm Mahajan <rhythm.m.mahajan@oracle.com>

The commit: 3f235279828c ("x86/cpu: Restore AMD's DE_CFG MSR after resume")
which was backported from the upstream commit: 2632daebafd0 renamed the
MSR_F10H_DECFG_LFENCE_SERIALIZE macro to MSR_AMD64_DE_CFG_LFENCE_SERIALIZE.
The fix for 4.14 and 4.9 changed MSR_F10H_DECFG_LFENCE_SERIALIZE to
MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT in the init_amd() function, but should
have used MSR_AMD64_DE_CFG_LFENCE_SERIALIZE.  This causes a discrepency in the
LFENCE serialization check in the init_amd() function.

This causes a ~16% sysbench memory regression, when running:
    sysbench --test=memory run

Fixes: 3f235279828c ("x86/cpu: Restore AMD's DE_CFG MSR after resume")
Signed-off-by: Rhythm Mahajan <rhythm.m.mahajan@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -950,7 +950,7 @@ static void init_amd(struct cpuinfo_x86
 		 * serializing.
 		 */
 		ret = rdmsrl_safe(MSR_AMD64_DE_CFG, &val);
-		if (!ret && (val & MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT)) {
+		if (!ret && (val & MSR_AMD64_DE_CFG_LFENCE_SERIALIZE)) {
 			/* A serializing LFENCE stops RDTSC speculation */
 			set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
 		} else {


