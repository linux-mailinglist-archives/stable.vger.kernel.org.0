Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D38E27BF9D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 10:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbgI2Idj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 04:33:39 -0400
Received: from mx0b-001ae601.pphosted.com ([67.231.152.168]:7056 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727605AbgI2Idi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 04:33:38 -0400
Received: from pps.filterd (m0077474.ppops.net [127.0.0.1])
        by mx0b-001ae601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 08T8WhDg027041;
        Tue, 29 Sep 2020 03:33:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=PODMain02222019;
 bh=AtIwfUh1HCIzakGZPbCRTiACRVBGHlN9GnO9jcbx4xw=;
 b=X0oh74U/KQiFwEdosAf7qYv/9ceW2j3MPcI+oM2+pXStajs0fIOj70peG43U3PJfGa9m
 7n64NmHH1PhHOwtFIoz8c48tqxX9WEJWGqfvVYZEIa33e54xPHOcHntdl54SODZzZ20j
 rTN2wFWK2fEKOzOuV7X+IRYTX7etYi0+Fd8ssxEmzLBWk4vzEeA7RFiB9DwJUkoeTRYM
 Gy3zDpSVfSNzq1O0TPJGd+oIzhzF/GtLkMfs4vnmcRtK//NvBUSnUtclpef/F7olH1Nv
 GsT6TdS8tH0cEg4TiV7Kbs87JEgQPWskGouEDkSVSZtYRRytDSxtcTfjFX4sQjDhyK4O 9Q== 
Received: from ediex01.ad.cirrus.com ([87.246.76.36])
        by mx0b-001ae601.pphosted.com with ESMTP id 33t22p3gy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Sep 2020 03:33:35 -0500
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 29 Sep
 2020 09:33:34 +0100
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.1913.5 via Frontend
 Transport; Tue, 29 Sep 2020 09:33:34 +0100
Received: from ediswmail.ad.cirrus.com (ediswmail.ad.cirrus.com [198.61.86.93])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id 516202C6;
        Tue, 29 Sep 2020 08:33:34 +0000 (UTC)
Date:   Tue, 29 Sep 2020 08:33:34 +0000
From:   Charles Keepax <ckeepax@opensource.cirrus.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH AUTOSEL 5.8 14/29] regmap: debugfs: Fix handling of name
 string for debugfs init delays
Message-ID: <20200929083334.GX10899@ediswmail.ad.cirrus.com>
References: <20200929013027.2406344-1-sashal@kernel.org>
 <20200929013027.2406344-14-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200929013027.2406344-14-sashal@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 clxscore=1031 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 impostorscore=0 suspectscore=2 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009290078
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 28, 2020 at 09:30:11PM -0400, Sasha Levin wrote:
> From: Charles Keepax <ckeepax@opensource.cirrus.com>
> 
> [ Upstream commit 94cc89eb8fa5039fcb6e3e3d50f929ddcccee095 ]
> 
> In regmap_debugfs_init the initialisation of the debugfs is delayed
> if the root node isn't ready yet. Most callers of regmap_debugfs_init
> pass the name from the regmap_config, which is considered temporary
> ie. may be unallocated after the regmap_init call returns. This leads
> to a potential use after free, where config->name has been freed by
> the time it is used in regmap_debugfs_initcall.
> 

Afraid this patch had some issues if you are back porting it you
definitely need to take these two patches as well:

commit 1d512ee861b80da63cbc501b973c53131aa22f29
regmap: debugfs: Fix more error path regressions

commit d36cb0205f034e943aa29e35b59c6a441f0056b5
regmap: debugfs: Add back in erroneously removed initialisation of ret

Thanks,
Charles
