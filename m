Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B065B0588
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 15:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiIGNoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 09:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiIGNnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 09:43:33 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB861A1A63
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 06:42:42 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220907134241epoutp0274a972f7148cfe563d4fe47dac552376~Sl9a9iEwk1773117731epoutp02o
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 13:42:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220907134241epoutp0274a972f7148cfe563d4fe47dac552376~Sl9a9iEwk1773117731epoutp02o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662558161;
        bh=gSif8NMM6wosPp4czbq6ghp4X8l/PNF06f6zjCg20J4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtZFBnhCReAdCTRt5xLswLQ40+P5Ozgj4oom1DD7qSPxxrbcnBrMg406vXJpVvHvx
         7al+O09Jw+DgSopsn3VwY5SyT60tjZ2p7LBajjtbKzAwum4vWH38MCqOv+Bbxwcft3
         NJzLx5ExTS7fqqARh6h8R3DKUW2QzJzytc8FI4UI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220907134240epcas5p28b2f86dd0e4f0da92c4e47ffd09a1eba~Sl9aPlwok0998509985epcas5p2c;
        Wed,  7 Sep 2022 13:42:40 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MN3NF5gpLz4x9Pp; Wed,  7 Sep
        2022 13:42:37 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5E.69.53458.DCF98136; Wed,  7 Sep 2022 22:42:37 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220907101827epcas5p2afa088ce5a591040094d2b49b928f3c2~SjLHHpNUm2030720307epcas5p20;
        Wed,  7 Sep 2022 10:18:27 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220907101827epsmtrp1e3eff56e01088162beff031f9e566d64~SjLHGv0t40915809158epsmtrp1s;
        Wed,  7 Sep 2022 10:18:27 +0000 (GMT)
X-AuditID: b6c32a4a-a5bff7000000d0d2-e3-63189fcd52b7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9C.B8.18644.3FF68136; Wed,  7 Sep 2022 19:18:27 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.109.115.6]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220907101825epsmtip154204b88be3cf7dd290da6f4ee1397bd~SjLFJqolx3175831758epsmtip1p;
        Wed,  7 Sep 2022 10:18:25 +0000 (GMT)
From:   Smitha T Murthy <smitha.t@samsung.com>
To:     linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     m.szyprowski@samsung.com, andrzej.hajda@intel.com,
        mchehab@kernel.org, alim.akhtar@samsung.com,
        aswani.reddy@samsung.com, pankaj.dubey@samsung.com,
        linux-fsd@tesla.com, aakarsh.jain@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] media: s5p-mfc: Fix to handle reference queue during
 finishing
Date:   Wed,  7 Sep 2022 16:02:27 +0530
Message-Id: <20220907103227.61088-3-smitha.t@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220907103227.61088-1-smitha.t@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42LZdlhTQ/fsfIlkg2/XtCye7pjJavFg3jY2
        i/uLP7NYHNq8ld1i0+NrrBYPX4VbXN41h82iZ8NWVou1R+6yWyzb9IfJYtHWL+wWd/dsY7RY
        sPERowOvx+I9L5k8Nq3qZPPYvKTeo2/LKkaPf01z2T0+b5ILYIvKtslITUxJLVJIzUvOT8nM
        S7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBulNJoSwxpxQoFJBYXKykb2dTlF9a
        kqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ3xv3ERc8EtwYodF96zNjB+
        4Oti5OSQEDCRWLduPWsXIxeHkMBuRonLO7cwQzifGCXObD/OBOF8ZpT4NmcbUBkHWMu+B6UQ
        8V2MEuc73kIVNTNJTPrzkQlkLpuAjsS396fZQGwRgVSJV+vWgu1gFuhmkrg7fz0zSEJYIFTi
        zd73rCA2i4CqxOydb8CaeQUsJd5/3sAEcaC8xOoNB8DqOQWsJN4dmQ8V/8su8f1REITtIvHp
        20VmCFtY4tXxLewQtpTEy/42KDtd4v7nZkYIu0BibsMWqDn2EgeuzGEB+YxZQFNi/S59iLCs
        xNRT68BKmAX4JHp/P4Eq55XYMQ/GVpJYdOYE1HgJiatvt7JC2B4SJ5dMArOFBHoZJdZPFp3A
        KDcLYcMCRsZVjJKpBcW56anFpgVGeanl8EhLzs/dxAhOilpeOxgfPvigd4iRiYPxEKMEB7OS
        CG/KDpFkId6UxMqq1KL8+KLSnNTiQ4ymwOCbyCwlmpwPTMt5JfGGJpYGJmZmZiaWxmaGSuK8
        U7QZk4UE0hNLUrNTUwtSi2D6mDg4pRqYLLhmRW/VZ3rZZMTKqPblvY+V47PjxgxrXxkUKRd7
        b+HVXiRcGH4hxOe9zPxgc+NwGzFW9sl3/xxcz9XitT3Z9JD2ijeeB4L8Yt4eZb+so39w1Ywn
        KbxHn5Z1JCS3SV8s5lHR/3NN5JPs6tVyc8X1WcO6zBszTb403BPYIxNQekbj0zd2xg0T79R+
        nTr3wp6Pms9uqlbcbgz4+0VtsRgn4+rnt69dKevbw7ui/bRokGuKuP4p67u96eqXEk9odv5n
        rVsda62ob1R1zfdo/e4l1aLPHnktqOo3b13w9sKP5vceNS+55ldFnXXS/F5/loujXSDgxJnk
        dTNDIwrjbt2M4bi2wWT3I5XYNU4uv2SUWIozEg21mIuKEwFaJPM7EwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWy7bCSnO7nfIlkg9a9chZPd8xktXgwbxub
        xf3Fn1ksDm3eym6x6fE1VouHr8ItLu+aw2bRs2Erq8XaI3fZLZZt+sNksWjrF3aLu3u2MVos
        2PiI0YHXY/Gel0wem1Z1snlsXlLv0bdlFaPHv6a57B6fN8kFsEVx2aSk5mSWpRbp2yVwZfxv
        XMRccEuwYseF96wNjB/4uhg5OCQETCT2PSjtYuTiEBLYwSjRuuQSWxcjJ1BcQmLl70mMELaw
        xMp/z9khihqZJH717AYrYhPQkfj2/jSYLSKQLjHpzlcWkCJmgelMEntWPWEH2SAsECxx+rwj
        SA2LgKrE7J1vmEBsXgFLifefNzBBLJCXWL3hADOIzSlgJfHuyHwmkFYhoJrjF6smMPItYGRY
        xSiZWlCcm55bbFhglJdarlecmFtcmpeul5yfu4kRHLRaWjsY96z6oHeIkYmD8RCjBAezkghv
        yg6RZCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqY0kXN
        LETuqP/8X3D9ru6RbvOpX2tYpihNOfZ2quMzhpkNe5N5HFZZqcV1ds87yRD4far7nKctj9a4
        eTD/OP1Eo96QpcY39t3+ExaiIqu2LnPTD+hVZT19bk0d35KlNn8c9N+WXU4/oTnjkmTavn77
        9NWhcu2LGm69tvDPYdryNa/V8hrP1N+PvY32pvGXSSnUyC+vUXu04ex2xmNS5lNvLbXL2Xaq
        pJidf8nnmBLTjTuKXvGqZXy4Jf+v75ZmZ5z2pw2N55SnqcxePyXu2szmO5/CW7PPv+UXmWpW
        xebzvP31Ub3XeQJ7PNkMhacI+Uc+CNj8ON3YcpKQLsOLNV1PbV93Fsxad8vqW/9zsSP5SizF
        GYmGWsxFxYkA1MJTBMkCAAA=
X-CMS-MailID: 20220907101827epcas5p2afa088ce5a591040094d2b49b928f3c2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220907101827epcas5p2afa088ce5a591040094d2b49b928f3c2
References: <20220907103227.61088-1-smitha.t@samsung.com>
        <CGME20220907101827epcas5p2afa088ce5a591040094d2b49b928f3c2@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On receiving last buffer driver puts MFC to MFCINST_FINISHING state which in
turn skips transferring of frame from SRC to REF queue. This causes driver to
stop MFC encoding and last frame is lost.

This patch guarantees safe handling of frames during MFCINST_FINISHING and
correct clearing of workbit to avoid early stopping of encoding.

Fixes: af93574678108 ("[media] MFC: Add MFC 5.1 V4L2 driver")

Cc: stable@vger.kernel.org
Cc: linux-fsd@tesla.com
Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
---
 drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c
index b65e506665af..e064bdd74f2e 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c
@@ -1218,6 +1218,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 	unsigned long mb_y_addr, mb_c_addr;
 	int slice_type;
 	unsigned int strm_size;
+	bool src_ready;
 
 	slice_type = s5p_mfc_hw_call(dev->mfc_ops, get_enc_slice_type, dev);
 	strm_size = s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev);
@@ -1257,7 +1258,8 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 			}
 		}
 	}
-	if ((ctx->src_queue_cnt > 0) && (ctx->state == MFCINST_RUNNING)) {
+	if ((ctx->src_queue_cnt > 0) && (ctx->state == MFCINST_RUNNING ||
+				ctx->state == MFCINST_FINISHING)) {
 		mb_entry = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
 									list);
 		if (mb_entry->flags & MFC_BUF_FLAG_USED) {
@@ -1288,7 +1290,13 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 		vb2_set_plane_payload(&mb_entry->b->vb2_buf, 0, strm_size);
 		vb2_buffer_done(&mb_entry->b->vb2_buf, VB2_BUF_STATE_DONE);
 	}
-	if ((ctx->src_queue_cnt == 0) || (ctx->dst_queue_cnt == 0))
+
+	src_ready = true;
+	if ((ctx->state == MFCINST_RUNNING) && (ctx->src_queue_cnt == 0))
+		src_ready = false;
+	if ((ctx->state == MFCINST_FINISHING) && (ctx->ref_queue_cnt == 0))
+		src_ready = false;
+	if ((!src_ready) || (ctx->dst_queue_cnt == 0))
 		clear_work_bit(ctx);
 
 	return 0;
-- 
2.17.1

