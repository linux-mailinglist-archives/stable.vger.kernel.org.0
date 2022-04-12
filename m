Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CE04FD714
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351424AbiDLHUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351687AbiDLHMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5E015A10;
        Mon, 11 Apr 2022 23:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF4D6B81B35;
        Tue, 12 Apr 2022 06:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A5EC385A6;
        Tue, 12 Apr 2022 06:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746295;
        bh=i89we5TJeVE6OkMcDfmOAm0MKkNg7SRdvldGSUnPKxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtxNo8HGGp1nmREzsUXCB3tX0MtxHleMqMENnOuyilgbOpcS7t4YvYd5nkMOZDomL
         MCNFtVhWRP4uP0R+nHKa1WCpfQqkxmZkg139qaHMV8mwUqhwIGPVm21GdBtzFGjHkm
         1TSl9JxUq4MDlMBVDLKJaEIcMgkjXov1//CmC4DQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 224/277] perf/x86/intel: Update the FRONTEND MSR mask on Sapphire Rapids
Date:   Tue, 12 Apr 2022 08:30:27 +0200
Message-Id: <20220412062948.526573265@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Kan Liang <kan.liang@linux.intel.com>

commit e590928de7547454469693da9bc7ffd562e54b7e upstream.

On Sapphire Rapids, the FRONTEND_RETIRED.MS_FLOWS event requires the
FRONTEND MSR value 0x8. However, the current FRONTEND MSR mask doesn't
support it.

Update intel_spr_extra_regs[] to support it.

Fixes: 61b985e3e775 ("perf/x86/intel: Add perf core PMU support for Sapphire Rapids")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1648482543-14923-2-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -281,7 +281,7 @@ static struct extra_reg intel_spr_extra_
 	INTEL_UEVENT_EXTRA_REG(0x012a, MSR_OFFCORE_RSP_0, 0x3fffffffffull, RSP_0),
 	INTEL_UEVENT_EXTRA_REG(0x012b, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
 	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
-	INTEL_UEVENT_EXTRA_REG(0x01c6, MSR_PEBS_FRONTEND, 0x7fff17, FE),
+	INTEL_UEVENT_EXTRA_REG(0x01c6, MSR_PEBS_FRONTEND, 0x7fff1f, FE),
 	INTEL_UEVENT_EXTRA_REG(0x40ad, MSR_PEBS_FRONTEND, 0x7, FE),
 	INTEL_UEVENT_EXTRA_REG(0x04c2, MSR_PEBS_FRONTEND, 0x8, FE),
 	EVENT_EXTRA_END


