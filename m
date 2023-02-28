Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDDE6A595C
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 13:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjB1MrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 07:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB1MrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 07:47:17 -0500
Received: from mx0b-001ae601.pphosted.com (mx0a-001ae601.pphosted.com [67.231.149.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6B22FCF1
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 04:47:16 -0800 (PST)
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
        by mx0a-001ae601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31SAOWcq012779;
        Tue, 28 Feb 2023 06:47:00 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=message-id : date :
 mime-version : from : subject : to : cc : content-type :
 content-transfer-encoding; s=PODMain02222019;
 bh=Vftv1dG/2GtDXpOzyvFzsBDtO6920k79GyNXwbMtL50=;
 b=HVobyr3HU757uF6OtE9Al4iH9nRefd995Av7olwt0u39pptuZe5B/inISRYjjULOvzTh
 Tlwc8zG9ZhuoN9UFuhSj4GbmfVAy2W2BY6ntjzpwP69rf2W5vsYvinv449lisnh6P5jB
 OBd6awbzlp7TSwY/1CQFqYgVpA8ExO7NpiRonYi8aD4DjSqzq9IMq7l0b/Z/nyF3BUuH
 IRZkW+DRTkN1lIf28hspuByzbAta7orhsKWv80zfq+sjOEhoSjiWtYxWy46IlGnbtM92
 fbVQR2BGUTveJlGhA9D536TtuAKY+/hK86d8dxxK2JihIXzSG+QMB/MilBxkw0TtsHRx 0g== 
Received: from ediex02.ad.cirrus.com ([84.19.233.68])
        by mx0a-001ae601.pphosted.com (PPS) with ESMTPS id 3nygm6vqxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 06:46:59 -0600
Received: from ediex01.ad.cirrus.com (198.61.84.80) by ediex02.ad.cirrus.com
 (198.61.84.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.25; Tue, 28 Feb
 2023 06:46:57 -0600
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by ediex01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.2.1118.25 via Frontend
 Transport; Tue, 28 Feb 2023 06:46:57 -0600
Received: from [198.90.251.127] (edi-sw-dsktp-006.ad.cirrus.com [198.90.251.127])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id A2971475;
        Tue, 28 Feb 2023 12:46:57 +0000 (UTC)
Message-ID: <c530b196-c668-8437-4792-951a82ea7c42@opensource.cirrus.com>
Date:   Tue, 28 Feb 2023 12:46:57 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
From:   Richard Fitzgerald <rf@opensource.cirrus.com>
Subject: stable/6.2: backport commit 943f4e64ee17 ("ALSA: hda: cs35l41:
 Correct error condition handling")
To:     <stable@vger.kernel.org>
CC:     Takashi Iwai <tiwai@suse.com>, Martin Wolf <info@martinwolf.pub>,
        - <patches@opensource.cirrus.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Il02JuQkQSp61ZG2umJoakFyNCX3_Jd1
X-Proofpoint-GUID: Il02JuQkQSp61ZG2umJoakFyNCX3_Jd1
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 943f4e64ee177cf44d7f2c235281fcda7c32bb28 upstream

Please backport to 6.2.

This fixes an API break between the cs_dsp driver and the cs35l41 HDA
driver that broke the cs35l41 driver.

The original chain of patches that made the cs_dsp change missed out the
corresponding change to the HDA code. These changes went into the first
6.2 release.

Reported-by: Martin Wolf <info@martinwolf.pub>

