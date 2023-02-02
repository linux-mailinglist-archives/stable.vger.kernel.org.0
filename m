Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C36688853
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 21:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjBBUjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 15:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbjBBUjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 15:39:46 -0500
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37EE719B6;
        Thu,  2 Feb 2023 12:39:45 -0800 (PST)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312JqYZj009139;
        Thu, 2 Feb 2023 20:39:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=qcppdkim1; bh=uYym2M5Sy0L04dUdD30gqZFjw9nSrj45EWQqDiGTxHE=;
 b=ae1ErA+lUxKcKWbbnextJUc29/7Rh7unRuwO2ELx8uJrX6rKr8KhZ3BgtuToLv3xOs7N
 inUbKbQwSlBMqmpGf0ErrsneLvi+TVLtN/Qhqx+4Zu3BH/EM9SCI6a86B4WxVD1he90m
 DkthZx/pYA988xO/5QYqOg6rQ7fIAMCRYxsmz5VvzjDUGNmnDV7u1T8F6XqbAKBN7F8I
 E7QfQVJLL54rBP5u6sqY30SSu9WuPQTOcLBgJNzj2MaKKgN/evr4SRUfSSs88sNhF7+r
 f8zErWhtGJ+OhAcQVmMqHdnQFbNy6xDL4Rf5HAeVp+5TPRLaCLz4KuX/Q41Trcs/Dv1J eA== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ng969sj2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 20:39:42 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 312KdfAx019669
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 2 Feb 2023 20:39:41 GMT
Received: from hu-jackp-lv.qualcomm.com (10.49.16.6) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 2 Feb 2023 12:39:41 -0800
Date:   Thu, 2 Feb 2023 12:39:36 -0800
From:   Jack Pham <quic_jackp@quicinc.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Linyu Yuan <quic_linyyuan@quicinc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wesley Cheng <quic_wcheng@quicinc.com>
Subject: Re: [PATCH] usb: dwc3: update link state when process wakeup
 interrupt
Message-ID: <20230202203936.GA4054742@hu-jackp-lv.qualcomm.com>
References: <1675221286-23833-1-git-send-email-quic_linyyuan@quicinc.com>
 <20230201190550.jozzrvwdi5lcwtbo@synopsys.com>
 <197a1446-9382-3d83-d26e-694e4d707679@quicinc.com>
 <20230202200956.kpyp6cq67anpxcie@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230202200956.kpyp6cq67anpxcie@synopsys.com>
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: j-WA05Hz84Rs03kNNqN4bavvVN82gUwZ
X-Proofpoint-GUID: j-WA05Hz84Rs03kNNqN4bavvVN82gUwZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_14,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=399
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 clxscore=1011
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302020183
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 02, 2023 at 08:10:01PM +0000, Thinh Nguyen wrote:
> On Thu, Feb 02, 2023, Linyu Yuan wrote:
> > 
> > On 2/2/2023 3:05 AM, Thinh Nguyen wrote:
> > > On Wed, Feb 01, 2023, Linyu Yuan wrote:
> > > > Consider there is interrpt sequences as suspend (U3) -> wakeup (U0) ->
> > > interrupt?
> > 
> > 
> > thanks, will change next version.
> > 
> > 
> > > 
> > > > suspend (U3), as there is no update to link state in wakeup interrupt,
> > > Instead of "no update", can you note in the commit that the link state
> > > change event is not enabled for most devices, so the driver doesn't
> > > update its link_state.
> > 
> > 
> > thanks, will change next version.
> > 
> > 
> > > 
> > > > the second suspend interrupt will not report to upper layer.
> > > > 
> > > > Fix it by update link state in wakeup interrupt handler.
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > Can you add fix tag?
> > 
> > 
> > seem this change can apply to all current stable kernel.
> 
> Did we have handling of suspend/resume since the beginning? If we did,
> please add a fix tag to the commit when the driver first added.
> 
> That helps to know that this is a fix patch.

Suspend was added with my change: d1d90dd27254 ("usb: dwc3: gadget: Enable suspend
events"), so arguably the link_state mismatch of $SUBJECT wouldn't have occurred
prior to that if suspend_interrupt() never got called right? ;)

But strictly speaking, wakeup_interrupt() was introduced all the way back
in the first commit 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
and had not been changed since.

Any preference which tag to choose for Fixes?

Jack
