Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9C666028B
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 15:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbjAFOvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 09:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbjAFOvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 09:51:19 -0500
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F5243A2C;
        Fri,  6 Jan 2023 06:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1673016677; x=1704552677;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6RpF6eE4rplQHZrScRm77jw6rc0zQcUrLHjokMOcVV8=;
  b=JYHFqGSUTGd5oQN+8FkiD2K3Mja81guR4QoRhZNfMgT6rtaUSS1sf2xx
   lOqXcP7krE0rqFC4JpI/RLTLgr4RYCqDfkT8DGrxw9569b5JgJSugv9mj
   0IMHQwFoCuMVbanNJirihLTgvC5crfSl3QpOajMjgekUb3VyGmZ1TVcl9
   4=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 06 Jan 2023 06:51:17 -0800
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 06:51:17 -0800
Received: from asutoshd-linux1.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 6 Jan 2023 06:51:16 -0800
Date:   Fri, 6 Jan 2023 06:51:06 -0800
From:   Asutosh Das <quic_asutoshd@quicinc.com>
To:     Jinyoung CHOI <j-young.choi@samsung.com>
CC:     Avri Altman <Avri.Altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "ALIM AKHTAR" <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Can Guo <quic_cang@quicinc.com>
Subject: Re: (2) [PATCH] scsi: ufs: core: fix devfreq deadlocks
Message-ID: <20230106145106.GA16911@asutoshd-linux1.qualcomm.com>
References: <DM6PR04MB65750DE015FA51FDC08D994BFCFA9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <20221222102121.18682-1-johan+linaro@kernel.org>
 <85e91255-1e6f-f428-5376-08416d2107a2@acm.org>
 <20230104141045.GB8114@asutoshd-linux1.qualcomm.com>
 <3db8c140-2e4e-0d75-4d81-b2c1f22f68d1@acm.org>
 <CGME20230105072134epcas2p47a72da1ee48e341295575770d3eb573c@epcms2p7>
 <20230106022456epcms2p784b3cf9115f6b170bdef0732258381ba@epcms2p7>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Disposition: inline
In-Reply-To: <20230106022456epcms2p784b3cf9115f6b170bdef0732258381ba@epcms2p7>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06 2023 at 18:25 -0800, Jinyoung CHOI wrote:
>>> On 1/4/23 06:10, Asutosh Das wrote:
>>> > Load based toggling of WB seemed fine to me then.
>>> > I haven't thought about another method to toggle WriteBooster yet.
>>> > Let me see if I can come up with something.
>>> > IMT if you have a mechanism in mind, please let me know.
>>>
>>> Hi Asutosh,
>>>
>>> Which UFS devices need this mechanism? All UFS devices I'm familiar with can
>>> achieve wire speed for large write requests without enabling the WriteBooster.
>>This feature assures SLC-performance for writes to the WriteBooster buffer.
>>So enabling it is advantageous as far as write performance.
>
>I agree with you. Also, it can be used in various ways.
>
>>As for the toggling functionality, compared to e.g. enabling it on init and leave it on,
>>some flash vendors require it because of device health considerations.
>>This is not the case for us, so let others to comment.
>
>In our case, it does not matter whether to toggle or not.
>To make the code simple, it seems to be a good way to enable it on init and leave it on.
>Considering device health, WB can be disabled through lifetime check.
>
>Thanks,
>Jinyoung.
>
Hi Jinyoung / Avri / Bart

My understanding during the WriteBooster development was that the endurance of
the SLC buffer is considerably less and hence it's *not* a good idea to always
keep it ON. From the spec,
"
7279 Whenever the endurance of the WriteBooster Buffer is consumed completely, a write command is
7280 processed as if WriteBooster feature was disabled. Therefore, it is recommended to set fWriteBoosterEn to
7281 one, only when WriteBooster performance is needed, so that WriteBooster feature can be used for a longer
7282 time.
"
Going by this toggling it to ON when the load is high and performance is needed seemed reasonable.

Now then, if you confirm that there's no considerable difference in the WB buffer lifetime by
either always keeping it on at init OR on-demand, then this toggle code should be removed.
I will talk to other UFS device vendors who may not be active in this list and get back.

-asd

>>
>>Thanks,
>>Avri
>>>
>>> Thanks,
>>>
>>> Bart.
>
