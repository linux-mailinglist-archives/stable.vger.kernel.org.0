Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE2F5EA42C
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbiIZLll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238287AbiIZLk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:40:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FC84D80C;
        Mon, 26 Sep 2022 03:45:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE98160BA5;
        Mon, 26 Sep 2022 10:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1E7C433C1;
        Mon, 26 Sep 2022 10:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189067;
        bh=EbzNcFdyCzwHoRdRE4DsMCPjZPvGEdjHYWMP72mW22s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wYF5CPE5k+Flt8TuIRHmjzCqKoiGzRB8tfTFDKMVt7/haKfYgqqckT8ASySbIrZE3
         Sr4RifuvUDXQY54xD+1sUz8PPaKSsBkEvnkzWJzcCzs4QHJ3f8s1nNngdiiUlCdrJg
         xgCGzykcONUaAFZ08UK2AAZ3jCSgR6x8E1V4f8ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sinan Kaya <Sinan.Kaya@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 061/207] net: mana: Add rmb after checking owner bits
Date:   Mon, 26 Sep 2022 12:10:50 +0200
Message-Id: <20220926100809.340503618@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

commit 6fd2c68da55c552f86e401ebe40c4a619025ef69 upstream.

Per GDMA spec, rmb is necessary after checking owner_bits, before
reading EQ or CQ entries.

Add rmb in these two places to comply with the specs.

Cc: stable@vger.kernel.org
Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Reported-by: Sinan Kaya <Sinan.Kaya@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Link: https://lore.kernel.org/r/1662928805-15861-1-git-send-email-haiyangz@microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -370,6 +370,11 @@ static void mana_gd_process_eq_events(vo
 			break;
 		}
 
+		/* Per GDMA spec, rmb is necessary after checking owner_bits, before
+		 * reading eqe.
+		 */
+		rmb();
+
 		mana_gd_process_eqe(eq);
 
 		eq->head++;
@@ -1107,6 +1112,11 @@ static int mana_gd_read_cqe(struct gdma_
 	if (WARN_ON_ONCE(owner_bits != new_bits))
 		return -1;
 
+	/* Per GDMA spec, rmb is necessary after checking owner_bits, before
+	 * reading completion info
+	 */
+	rmb();
+
 	comp->wq_num = cqe->cqe_info.wq_num;
 	comp->is_sq = cqe->cqe_info.is_sq;
 	memcpy(comp->cqe_data, cqe->cqe_data, GDMA_COMP_DATA_SIZE);


