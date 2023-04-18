Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5106E638D
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjDRMl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbjDRMl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:41:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E52413C3D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:41:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C43B863325
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D719AC433EF;
        Tue, 18 Apr 2023 12:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821677;
        bh=kbj36jtAV4D1b7Tsu97XVvIrmabLu59Ylra6ZXQ8xqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sliq+mnF/vKd5bjBJqtKVHKDDr7MT+lhSLoJe3kE2aM6UMaiEgiAq1oiFGrUxL5Tc
         AjhdMd8BKH7mwGFS2VHJTz72eSGQFtcdF6YJAIA9ddu/kGhhFRyCbFC08TtTgUnph/
         znw3Ud8S9R2ajQ69vkbzFS0VvbMa9a5vNTbXnbA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xi Ruoyao <xry111@xry111.site>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Chang Feng <flukehn@gmail.com>
Subject: [PATCH 5.15 91/91] nvme-pci: avoid the deepest sleep state on ZHITAI TiPro5000 SSDs
Date:   Tue, 18 Apr 2023 14:22:35 +0200
Message-Id: <20230418120308.722868604@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xi Ruoyao <xry111@xry111.site>

commit d5d3c100ac40dcb03959a6f1d2f0f13204c4f145 upstream.

ZHITAI TiPro5000 SSDs has the same APST sleep problem as its cousin,
TiPro7000.  The quirk for TiPro7000 has been added in
commit 6b961bce50e4 ("nvme-pci: avoid the deepest sleep state on
ZHITAI TiPro7000 SSDs"), use the same quirk for TiPro5000.

The ASPT data from "nvme id-ctrl /dev/nvme1":

vid       : 0x1e49
ssvid     : 0x1e49
sn        : ZTA21T0KA2227304LM
mn        : ZHITAI TiPlus5000 1TB
fr        : ZTA09139
[...]
ps    0 : mp:6.50W operational enlat:0 exlat:0 rrt:0 rrl:0
         rwt:0 rwl:0 idle_power:- active_power:-
ps    1 : mp:5.80W operational enlat:0 exlat:0 rrt:1 rrl:1
         rwt:1 rwl:1 idle_power:- active_power:-
ps    2 : mp:3.60W operational enlat:0 exlat:0 rrt:2 rrl:2
         rwt:2 rwl:2 idle_power:- active_power:-
ps    3 : mp:0.0500W non-operational enlat:5000 exlat:10000 rrt:3 rrl:3
         rwt:3 rwl:3 idle_power:- active_power:-
ps    4 : mp:0.0025W non-operational enlat:8000 exlat:45000 rrt:4 rrl:4
         rwt:4 rwl:4 idle_power:- active_power:-

Reported-and-tested-by: Chang Feng <flukehn@gmail.com>
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3390,6 +3390,8 @@ static const struct pci_device_id nvme_i
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1cc1, 0x5350),   /* ADATA XPG GAMMIX S50 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1e49, 0x0021),   /* ZHITAI TiPro5000 NVMe SSD */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x1e49, 0x0041),   /* ZHITAI TiPro7000 NVMe SSD */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0xc0a9, 0x540a),   /* Crucial P2 */


