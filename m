Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B1A5B0584
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 15:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiIGNoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 09:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiIGNnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 09:43:31 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770049F0F9
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 06:42:38 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220907134236epoutp040440e036f685177028458e46f6982842~Sl9WzoirJ2341623416epoutp04n
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 13:42:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220907134236epoutp040440e036f685177028458e46f6982842~Sl9WzoirJ2341623416epoutp04n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662558156;
        bh=uKppsoNnbbL+dhUZLkGDMSWsNgwF5YdpFD8OZ4YqNIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3nwaDuc483HcpxWzjrnkiTScdusDC2+K5+KSyMEWzcb78ofSCZUneEGsj/LXVKQK
         k3McfNmkHf7rfTNIytjkginuRl7kJYa1Xe4auBlSoHtSjhJGuQeiP4/kJkxLupjnI2
         4qxQt8O3P8hRtRGX9zS4a3kEzxbT+IkcQUhUTAxA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220907134235epcas5p49f392d6e525cb8459cfab7df0a4b0f41~Sl9WMhKqN2674426744epcas5p4M;
        Wed,  7 Sep 2022 13:42:35 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MN3N92ytbz4x9Pp; Wed,  7 Sep
        2022 13:42:33 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FA.76.54060.9CF98136; Wed,  7 Sep 2022 22:42:33 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220907101825epcas5p321eaebfafa5f69a9695d4b12532eccfd~SjLFDTbJ81838818388epcas5p37;
        Wed,  7 Sep 2022 10:18:25 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220907101825epsmtrp2970b3a9d4e4dd6e1878b16969760feaf~SjLFCTXPR2177721777epsmtrp2E;
        Wed,  7 Sep 2022 10:18:25 +0000 (GMT)
X-AuditID: b6c32a4b-be1ff7000000d32c-49-63189fc90da4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5A.B5.14392.1FF68136; Wed,  7 Sep 2022 19:18:25 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.109.115.6]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220907101823epsmtip1cc68be055fa7e75fa830ad8da451dde9~SjLDGOn923176031760epsmtip1m;
        Wed,  7 Sep 2022 10:18:23 +0000 (GMT)
From:   Smitha T Murthy <smitha.t@samsung.com>
To:     linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     m.szyprowski@samsung.com, andrzej.hajda@intel.com,
        mchehab@kernel.org, alim.akhtar@samsung.com,
        aswani.reddy@samsung.com, pankaj.dubey@samsung.com,
        linux-fsd@tesla.com, aakarsh.jain@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/3] media: s5p-mfc: Clear workbit to handle error condition
Date:   Wed,  7 Sep 2022 16:02:26 +0530
Message-Id: <20220907103227.61088-2-smitha.t@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220907103227.61088-1-smitha.t@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42LZdlhTS/fkfIlkg5cTRS2e7pjJavFg3jY2
        i/uLP7NYHNq8ld1i0+NrrBYPX4VbXN41h82iZ8NWVou1R+6yWyzb9IfJYtHWL+wWd/dsY7RY
        sPERowOvx+I9L5k8Nq3qZPPYvKTeo2/LKkaPf01z2T0+b5ILYIvKtslITUxJLVJIzUvOT8nM
        S7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBulNJoSwxpxQoFJBYXKykb2dTlF9a
        kqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ1x83cjc8Fjrorp/y0aGFdw
        djFyckgImEhMXNXJ2sXIxSEksJtRYvGWdUwQzidGiRXv9zNDON8YJQ5s7GaBafk1YSVUy15G
        ia8LlzFCOM1MEk9+/2MHqWIT0JH49v40G4gtIpAq8WrdWrAOZoFuJom789czgySEBXwk1vc9
        BStiEVCVuPzlJpjNK2Apcb5lOzPEOnmJ1RsOgNmcAlYS747MBztQQuAru8SFGW8ZIYpcJDZ3
        bmWFsIUlXh3fwg5hS0l8freXDcJOl7j/uRmqvkBibsMWJgjbXuLAlTlAv3EAXacpsX6XPkRY
        VmLqqXVgJcwCfBK9v59AlfNK7JgHYytJLDpzAmqVhMTVtyAncADZHhJXXyqChIUEehklZl2z
        ncAoNwthwQJGxlWMkqkFxbnpqcWmBcZ5qeXwSEvOz93ECE6KWt47GB89+KB3iJGJg/EQowQH
        s5IIb8oOkWQh3pTEyqrUovz4otKc1OJDjKbA4JvILCWanA9My3kl8YYmlgYmZmZmJpbGZoZK
        4rxTtBmThQTSE0tSs1NTC1KLYPqYODilGpjq95oaLpv0tMjPzmLiwfic9HA5z60yB3KcPVwf
        zFJXN8+RtX1/Yg73X8nvTYun77f9dU2gR46Vv7n78Zb0pxu2iyyx/L+rPCTmIfuv9D3T3s/K
        OzndROJawyPjANfzEYeWBwYw/rVaIiDSZJB9ZL2Oici0vufGrhUtairi923zJso1cE1I/3/k
        eufN33rzeJb1rK/1XKOu5C+T+r22c9exuXyx946tL2NqmRJuubfL2jq/nensTI9jrtYll4X/
        2mRzO248c+RqWYRWRZjiM5048U8qzKb/cuXeRCV73v9aHb175YWavWb+R++7MIsseq+wuueX
        3adFBQq1bak+Gxd0ReSf3xirG9xwTvvDPCWW4oxEQy3mouJEADQpRlUTBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSnO7HfIlkgwObRCye7pjJavFg3jY2
        i/uLP7NYHNq8ld1i0+NrrBYPX4VbXN41h82iZ8NWVou1R+6yWyzb9IfJYtHWL+wWd/dsY7RY
        sPERowOvx+I9L5k8Nq3qZPPYvKTeo2/LKkaPf01z2T0+b5ILYIvisklJzcksSy3St0vgyrj5
        u5G54DFXxfT/Fg2MKzi7GDk5JARMJH5NWMkKYgsJ7GaUmPi7CiIuIbHy9yRGCFtYYuW/5+xd
        jFxANY1MEs9mzWcCSbAJ6Eh8e3+aDcQWEUiXmHTnKwtIEbPAdCaJPauesIMkhAV8JNb3PQUr
        YhFQlbj85SaYzStgKXG+ZTszxAZ5idUbDoDZnAJWEu+OgCzgANpmKXH8YtUERr4FjAyrGCVT
        C4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGCg1ZLcwfj9lUf9A4xMnEwHmKU4GBWEuFN2SGS
        LMSbklhZlVqUH19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVAOTafV9D6NL
        Ge+8m/Vj7qW/OtN/6AefgNTFY+GdLWw6Opy54a+uTJ9Q5i8cc8mz9Mqrh569364/b+fe8CS/
        172/KiNUd0vN0YRdOq33khZuWqTn4pZ45soGufe9dU075cpfbQuwqhH8+cLuHHeLvXHlr13d
        0r8+7FOV//vacItl1YmN2/47Kx3J2nJJodK+ue3dCWfWzdHcnl3eb+olHN7tSmkWCeYRL7fo
        Wrl5gc5vvf6XFa9KDeSEJlk1F9zsaZcQz6gteTL3d++m5Usb9/HZhBR57VCu3CURflXqWpJ3
        yeuayMSKluoV+VdY5qnJFeflmXM/uuJj+lRVpCmV58W2G19mxHgvczcXCV0socRSnJFoqMVc
        VJwIAPSmdPbJAgAA
X-CMS-MailID: 20220907101825epcas5p321eaebfafa5f69a9695d4b12532eccfd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220907101825epcas5p321eaebfafa5f69a9695d4b12532eccfd
References: <20220907103227.61088-1-smitha.t@samsung.com>
        <CGME20220907101825epcas5p321eaebfafa5f69a9695d4b12532eccfd@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During error on CLOSE_INSTANCE command, ctx_work_bits was not getting cleared.
During consequent mfc execution NULL pointer dereferencing of this context led
to kernel panic. This patch fixes this issue by making sure to clear
ctx_work_bits always.

Fixes: 818cd91ab8c6e ("[media] s5p-mfc: Extract open/close MFC instance commands)

Cc: stable@vger.kernel.org
Cc: linux-fsd@tesla.com
Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
---
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c
index 72d70984e99a..6d3c92045c05 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c
@@ -468,8 +468,10 @@ void s5p_mfc_close_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
 	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	/* Wait until instance is returned or timeout occurred */
 	if (s5p_mfc_wait_for_done_ctx(ctx,
-				S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0))
+				S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0)){
+		clear_work_bit_irqsave(ctx);
 		mfc_err("Err returning instance\n");
+	}
 
 	/* Free resources */
 	s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers, ctx);
-- 
2.17.1

