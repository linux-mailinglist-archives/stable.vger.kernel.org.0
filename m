Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D2162462A
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 16:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiKJPlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 10:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbiKJPlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 10:41:46 -0500
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF892B1B2
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 07:41:44 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20221110154142euoutp01686cc281f1d66b27fb2be1988a0338da~mQ3nDsyOV3076430764euoutp014
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 15:41:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20221110154142euoutp01686cc281f1d66b27fb2be1988a0338da~mQ3nDsyOV3076430764euoutp014
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668094902;
        bh=fd5p8aksmy9UiVn+D8PCYzWaUuHsJ2tCEvCv/Rm0KCk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=LX3ntitBa9x6s55Bt5uFG3nnB27OzWD9LI1PxSaJGAAxXi4cWC6fFe37OqIH3i9GF
         EOljzwpnfm/NFBTwqq0LsB6VxNa+N9SmBJc8237rUMKTL8sBJzswyONAtmxbhYIcRZ
         +ECh2seSLq1/CdLNyUaEAXu/SISJlxOTJajDEcv4=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221110154141eucas1p2ef9f9a1299eb1e9705b0e7d51aeaf5fd~mQ3mmbuFC1919919199eucas1p2m;
        Thu, 10 Nov 2022 15:41:41 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 31.86.10112.5BB1D636; Thu, 10
        Nov 2022 15:41:41 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20221110154141eucas1p1e69a91704c32c07307a9c73b95e0d9a3~mQ3mOmKio0296002960eucas1p14;
        Thu, 10 Nov 2022 15:41:41 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221110154141eusmtrp24f23e9429f1247377d2faaddf4137383~mQ3mN8VaS2466524665eusmtrp2m;
        Thu, 10 Nov 2022 15:41:41 +0000 (GMT)
X-AuditID: cbfec7f4-cf3ff70000002780-af-636d1bb5c524
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 32.6E.08916.5BB1D636; Thu, 10
        Nov 2022 15:41:41 +0000 (GMT)
Received: from AMDC2765.digital.local (unknown [106.120.51.73]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221110154140eusmtip20734298fba776ec0fa098dfceb081455~mQ3lu_fMC1468614686eusmtip2e;
        Thu, 10 Nov 2022 15:41:40 +0000 (GMT)
From:   Marek Szyprowski <m.szyprowski@samsung.com>
To:     linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>, stable@vger.kernel.org
Subject: [PATCH v2] usb: dwc3: exynos: Fix remove() function
Date:   Thu, 10 Nov 2022 16:41:31 +0100
Message-Id: <20221110154131.2577-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsWy7djP87pbpXOTDR6/VLV4MG8bm0Xz4vVs
        Fntfb2W3mHF+H5PFomWtzBZrj9xlt1iw8RGjxaoFB9gdODzuXNvD5rF/7hp2j74tqxg9tuz/
        zOjxeZNcAGsUl01Kak5mWWqRvl0CV8biA7uZCjZyV3zb/JCxgfEqZxcjJ4eEgInEpWmL2LsY
        uTiEBFYwSjz5fZUZJCEk8IVRonFjAYT9mVFi9lEpmIZprTeYIRqWM0q0Nv9ngnCAGjZfu8oE
        UsUmYCjR9baLDcQWEXCQWLL0DhtIEbNAO5PE3+1zWEASwgI2Ev8/7wdbxyKgKrF1bzdYnBco
        /unEWXaIdfISqzccAFsnIdDJIdF86h8LRMJF4siKLqgiYYlXx7dA2TIS/3fOZ4JoaGeUWPD7
        PpQzgVGi4fktRogqa4k7534B3cQBdJOmxPpd+iCmhICjRMuFKAiTT+LGW0GQYmYgc9K26cwQ
        YV6JjjYhiBlqErOOr4PbevDCJWYI20Ni4ZHzjJCQi5Xo2fOTcQKj3CyEVQsYGVcxiqeWFuem
        pxYb5aWW6xUn5haX5qXrJefnbmIEJoXT/45/2cG4/NVHvUOMTByMhxglOJiVRHi5NbKThXhT
        EiurUovy44tKc1KLDzFKc7AoifOyzdBKFhJITyxJzU5NLUgtgskycXBKNTCtP/CVt9I3ZseC
        F50N8qY+Hg3S5rb/7ghqnePmybStFHjmV/hX//Irh59CTPcfe5hZFZ1jKA0V/Sdiu+Rw3q1X
        fNJBaRkfdXw/M2TUBIa+3tWY3HyQOfai0/7nypmPL17a+VnwpvpL9o8P9MwWzn8V15s85xD3
        9f5UM6eN2fb/+9ftcbn89cbHM6c/RW8PdqlYIp5cdeVhz9xyU9+4p3tkeMJCWrJrutM8i2d6
        prreVlk6fcOvVyo3DX8KLTVbKdy7MNTuxNwVO5Y76H/tb2XeLbGzIFRgbq24fPYz68XaL7Z8
        1+Jsf372psGLqvL75kvexd87Ecc351WLMVfykUSL3PgMlpffS287c+0QqlBiKc5INNRiLipO
        BACEpmNaeQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xe7pbpXOTDR6dFrB4MG8bm0Xz4vVs
        Fntfb2W3mHF+H5PFomWtzBZrj9xlt1iw8RGjxaoFB9gdODzuXNvD5rF/7hp2j74tqxg9tuz/
        zOjxeZNcAGuUnk1RfmlJqkJGfnGJrVK0oYWRnqGlhZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqR
        vl2CXsbiA7uZCjZyV3zb/JCxgfEqZxcjJ4eEgInEtNYbzF2MXBxCAksZJd6cXscGkZCRODmt
        gRXCFpb4c62LDaLoE6PE8qOX2UESbAKGEl1vu8AaRAScJDrXngYrYhboZJLY2b0HLCEsYCPx
        //N+ZhCbRUBVYuvebhYQmxco/unEWXaIDfISqzccYJ7AyLOAkWEVo0hqaXFuem6xoV5xYm5x
        aV66XnJ+7iZGYEBuO/Zz8w7Gea8+6h1iZOJgPMQowcGsJMLLrZGdLMSbklhZlVqUH19UmpNa
        fIjRFGjfRGYp0eR8YEzklcQbmhmYGpqYWRqYWpoZK4nzehZ0JAoJpCeWpGanphakFsH0MXFw
        SjUw6b89Mzes4GzLNYVFds+TPxatPDrTZlFKQaqzpkiFUsOUdW8eXprsFDDFjkH87bZl7z0U
        0pqM3rYcVz+Xx1H2+c/j8juOhe/Y+Vs3RcZfiem20rqwi9tz4joLW7NtJqv2/FL6uXjO//eL
        plmvi+J17lC2WPeoNsvY8dOPi8qCEUtmZXYfvrZw68HPBxXrdZ7emZe74V3Ho4O65+4cT5KV
        nHxEOnBG0Mqt4r/vnu26tFw7rWahIMe6UHWpY+Xxx9m0unSfbXN3uvlHc3vgpLUTGzLaH1wS
        XLLl3cm/OyfM2az7Xltgxf5NUqVbvRxM/yuG3le3i1/01+Kr3spvE6x/btFkb1z368vCdc05
        qmb7OSOUWIozEg21mIuKEwGAGZX+0QIAAA==
X-CMS-MailID: 20221110154141eucas1p1e69a91704c32c07307a9c73b95e0d9a3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20221110154141eucas1p1e69a91704c32c07307a9c73b95e0d9a3
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221110154141eucas1p1e69a91704c32c07307a9c73b95e0d9a3
References: <CGME20221110154141eucas1p1e69a91704c32c07307a9c73b95e0d9a3@eucas1p1.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The core DWC3 device node was not properly removed by the custom
dwc3_exynos_remove_child() function. Replace it with generic
of_platform_depopulate() which does that job right.

Fixes: adcf20dcd262 ("usb: dwc3: exynos: Use of_platform API to create dwc3 core pdev")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc: stable@vger.kernel.org
---
 drivers/usb/dwc3/dwc3-exynos.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 0ecf20eeceee..4be6a873bd07 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -37,15 +37,6 @@ struct dwc3_exynos {
 	struct regulator	*vdd10;
 };
 
-static int dwc3_exynos_remove_child(struct device *dev, void *unused)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-
-	platform_device_unregister(pdev);
-
-	return 0;
-}
-
 static int dwc3_exynos_probe(struct platform_device *pdev)
 {
 	struct dwc3_exynos	*exynos;
@@ -142,7 +133,7 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 	struct dwc3_exynos	*exynos = platform_get_drvdata(pdev);
 	int i;
 
-	device_for_each_child(&pdev->dev, NULL, dwc3_exynos_remove_child);
+	of_platform_depopulate(&pdev->dev);
 
 	for (i = exynos->num_clks - 1; i >= 0; i--)
 		clk_disable_unprepare(exynos->clks[i]);
-- 
2.17.1

