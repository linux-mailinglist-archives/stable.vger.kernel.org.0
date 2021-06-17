Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801C13AAB45
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 07:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhFQFtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 01:49:02 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25610 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbhFQFtB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 01:49:01 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210617054651epoutp017fb28dc660444b9ed3225442b933a069~JSHXcYyzC1857018570epoutp01w
        for <stable@vger.kernel.org>; Thu, 17 Jun 2021 05:46:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210617054651epoutp017fb28dc660444b9ed3225442b933a069~JSHXcYyzC1857018570epoutp01w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623908811;
        bh=6yTdXCtcMhIWw57WbRSwU6NBc0qFsTyI3S96cv8gatc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbV18WkIx18uV0EuYgKKD5cFQPmSLZ9eEbLqnxHy7iEAlUZDkzeW8lkpaEVjPJPOb
         ifEG5MxdyV4bLllYxRphS13kkvT5c4kzDX4p1+FBdGjCojN0h6wSl9dy/dOj8BOApM
         D3bmOZFhauexz58CTVIxcyKqS9LC4keyBgmmQI6g=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210617054651epcas1p2374af237de7a1e641dfa5f31f18c2de1~JSHXAStug2425124251epcas1p2d;
        Thu, 17 Jun 2021 05:46:51 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.152]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4G59zX0y0dz4x9QJ; Thu, 17 Jun
        2021 05:46:48 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        AE.3F.09578.8C1EAC06; Thu, 17 Jun 2021 14:46:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210617054647epcas1p4d2e5b1fa1ec35487701189808178da18~JSHThFDxO2867228672epcas1p49;
        Thu, 17 Jun 2021 05:46:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210617054647epsmtrp2ce77117d4c3e7da576649933a306743b~JSHTgMPuf2416724167epsmtrp2_;
        Thu, 17 Jun 2021 05:46:47 +0000 (GMT)
X-AuditID: b6c32a35-58cdfa800000256a-25-60cae1c83607
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F6.96.08163.7C1EAC06; Thu, 17 Jun 2021 14:46:47 +0900 (KST)
Received: from localhost.localdomain (unknown [10.113.221.102]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210617054647epsmtip1e8df5f7be061f5db532fb458eccbd409~JSHTRkLrK1583415834epsmtip1g;
        Thu, 17 Jun 2021 05:46:47 +0000 (GMT)
From:   Chanwoo Choi <cw00.choi@samsung.com>
To:     andrew-sh.cheng@mediatek.com, hsinyi@chromium.org
Cc:     sibis@codeaurora.org, saravanak@google.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, chanwoo@kernel.org, cwchoi00@gmail.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/4] PM / devfreq: passive: Fix get_target_freq when not
 using required-opp
Date:   Thu, 17 Jun 2021 15:05:43 +0900
Message-Id: <20210617060546.26933-2-cw00.choi@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210617060546.26933-1-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdlhTT/fEw1MJBnvPMFtsX/+C1WLijSss
        Fte/PGe1eHZU22JC63Zmi7NNb9gtLu+aw2bxufcIo8XtxhVsFl2H/rJZXFv4ntViwcZHjA48
        HrMbLrJ4XO7rZfLYOesuu8eCTaUem1Z1snm0nNzP4tG3ZRWjx+dNcgEcUdk2GamJKalFCql5
        yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDHKimUJeaUAoUCEouLlfTt
        bIryS0tSFTLyi0tslVILUnIKLAv0ihNzi0vz0vWS83OtDA0MjEyBChOyMxb+W8dScIWr4v7n
        I0wNjO84uhg5OCQETCRmvErqYuTkEBLYwSix8HR9FyMXkP2JUeLb08VMEM5nRonPFw+yg1SB
        NJya08UGkdjFKLHz50EWCOcLo8SLnU1sIFVsAloS+1/cALNFBEwl9hyeCFbELPCDUWLS0RY2
        kN3CArESe+4WgdSwCKhKTD/4lwXE5hWwkpg4Zz0bxDZ5idUbDjCD2JwC1hLnltxhB5kjIdDI
        IfFny3wmiCIXia071rFC2MISr45vgTpVSuLzu71Qg6olVp48wgbR3MEosWX/BagGY4n9Sycz
        gRzELKApsX6XPkRYUWLn77mMIDazAJ/Eu689rJDw4pXoaBOCKFGWuPzgLtQJkhKL2zuhVnlI
        LN3XAQ26PkaJy6daGScwys1C2LCAkXEVo1hqQXFuemqxYYEhcoxtYgQnRi3THYwT337QO8TI
        xMF4iFGCg1lJhFe3+ESCEG9KYmVValF+fFFpTmrxIUZTYOhNZJYSTc4Hpua8knhDUyNjY2ML
        E0MzU0NDJXHenWyHEoQE0hNLUrNTUwtSi2D6mDg4pRqYur3WCrrVzn21uGLxwQTxhEX5X+9Y
        KinYTns194ijzunwhzuuFb8ztP8m9W7754n3FSsDW033XjeZtCzHJj1O5O/fl57zVibX3Lxl
        cYjpJ/OWz9d22rteEH6muqrlYOuLZ1v3JSoxVqiunPHNgW9VrDrH0pPHLEJZv3g/F5i4sdn0
        cE/m3uzlPpH3LfdYiziEbekSqQp5uUxNY0q6dLVuNv/TD3vPqPt/vblwx5SFz85pMWal1hvm
        mk8T+/P49sNb8qu2JZ58OMuc4duWgzP4qq2Wve44G9mfMoG9xyVfIsT52tVXfH82pMX2/Tyd
        +PYOZ81brRz2MkdzPsbft0S1Lmr++zh5Uu78o+IckbvaspVYijMSDbWYi4oTAQi+S3wVBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsWy7bCSnO7xh6cSDCa8ELPYvv4Fq8XEG1dY
        LK5/ec5q8eyotsWE1u3MFmeb3rBbXN41h83ic+8RRovbjSvYLLoO/WWzuLbwPavFgo2PGB14
        PGY3XGTxuNzXy+Sxc9Zddo8Fm0o9Nq3qZPNoObmfxaNvyypGj8+b5AI4orhsUlJzMstSi/Tt
        ErgyFv5bx1Jwhavi/ucjTA2M7zi6GDk5JARMJE7N6WLrYuTiEBLYwSgxp+MLI0RCUmLaxaPM
        XYwcQLawxOHDxRA1nxgl3qyYAFbDJqAlsf/FDTaQGhEBc4njV6JBapgFWpgkNn7uYAapERaI
        lthzawoLiM0ioCox/eBfMJtXwEpi4pz1bBC75CVWbzgAVs8pYC1xbskddpCZQkA151+lT2Dk
        W8DIsIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzh8tbR2MO5Z9UHvECMTB+MhRgkO
        ZiURXt3iEwlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1
        MO0vXJwofojTgH/6RNnvDM8diibOb9i6qPHhPI0Zqtwp5y+JSK4OZNBtO/G6yEDlo+LSjdx9
        ihKnOQP2n5t+Ir6b9e8ki7KGi5GVr6ZyVbQdcXeu/al7cI5Yz99jOfM2LujdxL9Ckasqw9H0
        sOl9gZKW0yfSvMSEHtr5zv23/Mb8CLXNEmejkx5qtKo/4z6ypvu5ld3hff91ehx8mPc4KYfx
        zVq/8MJ529Xuzs6mhkkvvryVC/rgsU5i4WG5aZEFXO8Ld5tWPQ6Sr9FcHuOrfffC5pb3uYcd
        im5tZvds6f1ozK+bxS6wfddOuehnmz/P/JBq66yqfOyLNu+mxoN/PTWmFeyayXmlu49HnWX3
        DSWW4oxEQy3mouJEAOQ9JDLOAgAA
X-CMS-MailID: 20210617054647epcas1p4d2e5b1fa1ec35487701189808178da18
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210617054647epcas1p4d2e5b1fa1ec35487701189808178da18
References: <20210617060546.26933-1-cw00.choi@samsung.com>
        <CGME20210617054647epcas1p4d2e5b1fa1ec35487701189808178da18@epcas1p4.samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The 86ad9a24f21e ("PM / devfreq: Add required OPPs support to passive governor")
supported the required-opp property for using devfreq passive governor.
But, 86ad9a24f21e has caused the problem on use-case when required-opp
is not used such as exynos-bus.c devfreq driver. So that fix the
get_target_freq of passive governor for supporting the case of when
required-opp is not used.

Cc: stable@vger.kernel.org
Fixes: 86ad9a24f21e ("PM / devfreq: Add required OPPs support to passive governor")
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/governor_passive.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/governor_passive.c b/drivers/devfreq/governor_passive.c
index b094132bd20b..fc09324a03e0 100644
--- a/drivers/devfreq/governor_passive.c
+++ b/drivers/devfreq/governor_passive.c
@@ -65,7 +65,7 @@ static int devfreq_passive_get_target_freq(struct devfreq *devfreq,
 		dev_pm_opp_put(p_opp);
 
 		if (IS_ERR(opp))
-			return PTR_ERR(opp);
+			goto no_required_opp;
 
 		*freq = dev_pm_opp_get_freq(opp);
 		dev_pm_opp_put(opp);
@@ -73,6 +73,7 @@ static int devfreq_passive_get_target_freq(struct devfreq *devfreq,
 		return 0;
 	}
 
+no_required_opp:
 	/*
 	 * Get the OPP table's index of decided frequency by governor
 	 * of parent device.
-- 
2.17.1

