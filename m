Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C4752E2FC
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 05:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344726AbiETDRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 23:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345104AbiETDRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 23:17:44 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1AF5A585;
        Thu, 19 May 2022 20:17:43 -0700 (PDT)
X-UUID: 4737285e739243b3bb600eb2e528098b-20220520
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:ffea6a91-f043-40ea-9b64-507b503b30d4,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:14,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:14
X-CID-META: VersionHash:2a19b09,CLOUDID:07daf179-5ef6-470b-96c9-bdb8ced32786,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:3,EDM:-3,IP:nil,URL:0,File:nil
        ,QS:0,BEC:nil
X-UUID: 4737285e739243b3bb600eb2e528098b-20220520
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <rex-bc.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1504191338; Fri, 20 May 2022 11:17:39 +0800
Received: from mtkmbs07n1.mediatek.inc (172.21.101.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 20 May 2022 11:17:37 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 20 May 2022 11:17:37 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 20 May 2022 11:17:37 +0800
Message-ID: <319484715f582c210c275ef23d020e802579c738.camel@mediatek.com>
Subject: Re: [PATCH v7,3/4] drm/mediatek: keep dsi as LP00 before dcs cmds
 transfer
From:   Rex-BC Chen <rex-bc.chen@mediatek.com>
To:     <xinlei.lee@mediatek.com>, <chunkuang.hu@kernel.org>,
        <p.zabel@pengutronix.de>, <airlied@linux.ie>, <daniel@ffwll.ch>,
        <matthias.bgg@gmail.com>
CC:     <dri-devel@lists.freedesktop.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        <jitao.shi@mediatek.com>,
        "# 5 . 10 . x : b255d51e3967 : sched : Modify dsi funcs to atomic 
        operations" <stable@vger.kernel.org>
Date:   Fri, 20 May 2022 11:17:36 +0800
In-Reply-To: <1653012007-11854-4-git-send-email-xinlei.lee@mediatek.com>
References: <1653012007-11854-1-git-send-email-xinlei.lee@mediatek.com>
         <1653012007-11854-4-git-send-email-xinlei.lee@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-05-20 at 10:00 +0800, xinlei.lee@mediatek.com wrote:
> From: Jitao Shi <jitao.shi@mediatek.com>
> 
> To comply with the panel sequence, hold the mipi signal to LP00
> before the dcs cmds transmission,
> and pull the mipi signal high from LP00 to LP11 until the start of
> the dcs cmds transmission.
> The normal panel timing is :
> (1) pp1800 DC pull up
> (2) avdd & avee AC pull high
> (3) lcm_reset pull high -> pull low -> pull high
> (4) Pull MIPI signal high (LP11) -> initial code -> send video
> data(HS mode)
> The power-off sequence is reversed.
> If dsi is not in cmd mode, then dsi will pull the mipi signal high in
> the mtk_output_dsi_enable function.
> The delay in lane_ready func is the reaction time of dsi_rx after
> pulling up the mipi signal.
> 
> Fixes: 2dd8075d2185 ("drm/mediatek: mtk_dsi: Use the drm_panel_bridge
> API")
> 
> Cc: <stable@vger.kernel.org> # 5.10.x: b255d51e3967: sched: Modify
> dsi funcs to atomic operations
> Cc: <stable@vger.kernel.org> # 5.10.x: 72c69c977502: sched: Separate
> poweron/poweroff from enable/disable and define new funcs
> Cc: <stable@vger.kernel.org> # 5.10.x
> Signed-off-by: Jitao Shi <jitao.shi@mediatek.com>
> Signed-off-by: Xinlei Lee <xinlei.lee@mediatek.com>
> Reviewed-by: AngeloGioacchino Del Regno <
> angelogioacchino.delregno@collabora.com>
> ---

Reviewed-by: Rex-BC Chen <rex-bc.chen@mediatek.com>

