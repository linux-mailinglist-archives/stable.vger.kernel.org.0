Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9853F5B0582
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 15:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiIGNoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 09:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiIGNna (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 09:43:30 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C29A00C3
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 06:42:34 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220907134230epoutp0227b11cc1c1e8138f7449b217c76d137b~Sl9Q6grTF1773117731epoutp02j
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 13:42:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220907134230epoutp0227b11cc1c1e8138f7449b217c76d137b~Sl9Q6grTF1773117731epoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662558150;
        bh=ANdL1iNQslYKX0O7F+SUtWXTCE68cYMhgQFXj3+NFRM=;
        h=From:To:Cc:Subject:Date:References:From;
        b=iVA2UcLYS6RVNpl+vdRpa/cdLieGL9k7WE6psTA13ZQsSoxXLMVJ/Z55UeL0AWwsn
         WfGW5HFVzsaXmvL0KZhJdNi5STjBvyX8ioftYSZ3ANdhW013CtFK3DrMpLaiDv1iNL
         5HVeYXJVrUYsa8ZhOkQaTgaAITjNSU08Y/dMGyHs=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220907134229epcas5p25dddca5096ab3e487c0687e607395e6d~Sl9QPIzoA3275732757epcas5p2M;
        Wed,  7 Sep 2022 13:42:29 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4MN3N319rFz4x9Pv; Wed,  7 Sep
        2022 13:42:27 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3F.8D.59633.2CF98136; Wed,  7 Sep 2022 22:42:27 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220907101823epcas5p22148836690ecf1d8e0e7ab81fd9aee28~SjLDBDE2o2030720307epcas5p2s;
        Wed,  7 Sep 2022 10:18:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220907101823epsmtrp1110f571454dca32c497880f174410d28~SjLDAFP_30915809158epsmtrp1o;
        Wed,  7 Sep 2022 10:18:23 +0000 (GMT)
X-AuditID: b6c32a49-dfdff7000000e8f1-8d-63189fc28adf
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.B5.14392.FEF68136; Wed,  7 Sep 2022 19:18:23 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.109.115.6]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220907101821epsmtip15bcc546cd6fb245d2ce800bc465375f9~SjLBD6oKc3253232532epsmtip1r;
        Wed,  7 Sep 2022 10:18:21 +0000 (GMT)
From:   Smitha T Murthy <smitha.t@samsung.com>
To:     linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     m.szyprowski@samsung.com, andrzej.hajda@intel.com,
        mchehab@kernel.org, alim.akhtar@samsung.com,
        aswani.reddy@samsung.com, pankaj.dubey@samsung.com,
        linux-fsd@tesla.com, aakarsh.jain@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/3] media: s5p-mfc: Fix in register read and write for H264
Date:   Wed,  7 Sep 2022 16:02:25 +0530
Message-Id: <20220907103227.61088-1-smitha.t@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEKsWRmVeSWpSXmKPExsWy7bCmpu7h+RLJBi//M1o83TGT1eLBvG1s
        FvcXf2axOLR5K7vFpsfXWC0evgq3uLxrDptFz4atrBZrj9xlt1i26Q+TxaKtX9gt7u7Zxmix
        YOMjRgdej8V7XjJ5bFrVyeaxeUm9R9+WVYwe/5rmsnt83iQXwBaVbZORmpiSWqSQmpecn5KZ
        l26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKeSQlliTilQKCCxuFhJ386mKL+0
        JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITvj2JrnLAV/RCqurP7E1MB4
        SrCLkZNDQsBE4vGJV6wgtpDAbkaJSzfLuhi5gOxPjBKv53YzQjjfGCV+NR9hg+lYcfw5E0Ri
        L6PEzwXboaqamSRONJ5kAaliE9CR+Pb+NFiHiECqxKt1a1lBipgFupkk7s5fzwySEBbwkfgw
        ZT4TiM0ioCrxsG8mexcjBwevgKXE++PVENvkJVZvOMAMYT9il3hygQnCdpF4/HQr1EXCEq+O
        b2GHsKUkXva3QdnpEvc/NzNC2AUScxu2QPXaSxy4MocFZBWzgKbE+l36EGFZiamn1oGVMAvw
        SfT+fgJVziuxYx6MrSSx6MwJqPESElffbmWFsD0kWp/eBxspJBArcXh13QRG2VkICxYwMq5i
        lEwtKM5NTy02LTDMSy2HR1Nyfu4mRnDi0/LcwXj3wQe9Q4xMHIyHGCU4mJVEeFN2iCQL8aYk
        VlalFuXHF5XmpBYfYjQFBthEZinR5Hxg6s0riTc0sTQwMTMzM7E0NjNUEuedos2YLCSQnliS
        mp2aWpBaBNPHxMEp1cBkX3dxUsPV9S//bw0JZPAJnDsvQoRHYpfJYctnV2ZndZ+skSmwWphQ
        y7DU+FJdwIyr9w44lBy58SD5bty02/lh0t9ce/VP/2DokDi/ekHeiSuqXTNfX3u7YfLCO1rH
        mzaeXyyr0rz3bdPkH7Yle2+/7DZwS4nfx79fvb5RopepYtWEkh07Fk+6Ml1pnUoYZ05KVJ14
        lNuUfCm9Yyvnu8/49aH1bb6R/8nKHI6Z4m7X9jvoZYZEJT1Yejyzc2qo5dUDj55u6RPefP/d
        u8cO6S5/+zZbVyvWsoV9FzuVbrgq00Cw6b/gr4a6oGc3g50jOSeGbJvrd9fv0vTKFAnpc86H
        C9oDvjo/iVSZc+bIeyY2JZbijERDLeai4kQAn/LSAQUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsWy7bCSnO77fIlkg8M7OSye7pjJavFg3jY2
        i/uLP7NYHNq8ld1i0+NrrBYPX4VbXN41h82iZ8NWVou1R+6yWyzb9IfJYtHWL+wWd/dsY7RY
        sPERowOvx+I9L5k8Nq3qZPPYvKTeo2/LKkaPf01z2T0+b5ILYIvisklJzcksSy3St0vgyji2
        5jlLwR+RiiurPzE1MJ4S7GLk5JAQMJFYcfw5UxcjF4eQwG5GiSWPp7NDJCQkVv6exAhhC0us
        /PecHaKokUnixvHHrCAJNgEdiW/vT7OB2CIC6RKT7nxlASliFpjOJLFn1ROwScICPhIfpsxn
        ArFZBFQlHvbNBIpzcPAKWEq8P14NsUBeYvWGA8wTGHkWMDKsYpRMLSjOTc8tNiwwzEst1ytO
        zC0uzUvXS87P3cQIDkQtzR2M21d90DvEyMTBeIhRgoNZSYQ3ZYdIshBvSmJlVWpRfnxRaU5q
        8SFGaQ4WJXHeC10n44UE0hNLUrNTUwtSi2CyTBycUg1Mlh+PJKyY+1JLdnfJuzd2HcL+r5tr
        mJNVX7DNPZZuWybYMLP/hfnH6aK1k9atm7y4/tbr4xWzxO3UtlcrWGmp7DyXaXf8yKnXDPm3
        tsrJlLkJ5X/qOWYg5CNtc8mqf3urFUtSaLNAdQI7o9i1id9X8x1ZySd3nWtCYVWhtdaSF+L2
        rAsPhCp3ZO7b8i+6z/Tsd81JN5OvVm2JN6n+/sBnkdfhU2ddLkx/s13lWt2fIzLr/1UdPSug
        7nFqorD47DoX2Re33745v9HgmkHXaQfrLav27qo5zxi0U0ptyZebP0qPb9ety1u9e0NB7L4T
        5xtMFb3yjCX3GJ+5WJkZdDH4u3jPp+Q6fhuHteeq3rfYK7EUZyQaajEXFScCAKKuiDqzAgAA
X-CMS-MailID: 20220907101823epcas5p22148836690ecf1d8e0e7ab81fd9aee28
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220907101823epcas5p22148836690ecf1d8e0e7ab81fd9aee28
References: <CGME20220907101823epcas5p22148836690ecf1d8e0e7ab81fd9aee28@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Few of the H264 encoder registers written were not getting reflected
since the read values was not stored and getting overwritten.

Fixes: 6a9c6f6812579 ("[media] s5p-mfc: Add variants to access mfc registers")

Cc: stable@vger.kernel.org
Cc: linux-fsd@tesla.com
Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
---
 .../platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c      | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c
index 8227004f6746..c0df5ac9fcff 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1060,7 +1060,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	}
 
 	/* aspect ratio VUI */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 5);
 	reg |= ((p_h264->vui_sar & 0x1) << 5);
 	writel(reg, mfc_regs->e_h264_options);
@@ -1083,7 +1083,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 
 	/* intra picture period for H.264 open GOP */
 	/* control */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 4);
 	reg |= ((p_h264->open_gop & 0x1) << 4);
 	writel(reg, mfc_regs->e_h264_options);
@@ -1097,23 +1097,23 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	}
 
 	/* 'WEIGHTED_BI_PREDICTION' for B is disable */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x3 << 9);
 	writel(reg, mfc_regs->e_h264_options);
 
 	/* 'CONSTRAINED_INTRA_PRED_ENABLE' is disable */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 14);
 	writel(reg, mfc_regs->e_h264_options);
 
 	/* ASO */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 6);
 	reg |= ((p_h264->aso & 0x1) << 6);
 	writel(reg, mfc_regs->e_h264_options);
 
 	/* hier qp enable */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 8);
 	reg |= ((p_h264->open_gop & 0x1) << 8);
 	writel(reg, mfc_regs->e_h264_options);
@@ -1134,7 +1134,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	writel(reg, mfc_regs->e_h264_num_t_layer);
 
 	/* frame packing SEI generation */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 25);
 	reg |= ((p_h264->sei_frame_packing & 0x1) << 25);
 	writel(reg, mfc_regs->e_h264_options);
-- 
2.17.1

