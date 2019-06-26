Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A260456ED9
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 18:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfFZQcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 12:32:16 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:18750 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726674AbfFZQcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 12:32:15 -0400
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5QGWARp001486;
        Wed, 26 Jun 2019 17:32:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=TR/q/jg7IYamEH1Qu4WUmbvI4OmK5BJ2djDDaorU5QI=;
 b=cXTOFz5SIeIZiErTjsbIi9ok0Kzx/Y13XaqE0kCTRMkGaIc0ZjVzCuAKBIxKFhB/ZJGe
 nwzYwxhiuSzjk1KEk+Hu2tehV+3iBmvA/vHzhGzytnbkh26kCDwZQ8UcMrtEIh3BVXuC
 vrlwn72lhqlcp42qjPgkhbGVtMJrOtS3YLhyA8afA3H8sLy+721oeKMMPm4SJlzDVQRE
 D4PE1qJPeLkOXSnww5FrO1zSaOBU4ShYGr4SA6XICZ8ArpSIu0XBG4FIKZPo9fvgU7OL
 nFulLqx0G8KmVJSLBjpQg+JsWXXkfm62SeVQ1yAV+vccvbugFxzTUvTY6tG3ZBWj8jLX NA== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2tbh6e5ecm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 17:32:10 +0100
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x5QGVtpv023615;
        Wed, 26 Jun 2019 12:32:04 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint2.akamai.com with ESMTP id 2t9fnwyt7v-1;
        Wed, 26 Jun 2019 12:32:04 -0400
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 30F4C2211A;
        Wed, 26 Jun 2019 16:28:56 +0000 (GMT)
Subject: Re: [PATCH 4.14] tcp: refine memory limit test in tcp_fragment()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        stable@vger.kernel.org, jbaron@akamai.com
References: <1561483177-30254-1-git-send-email-johunt@akamai.com>
 <20190625202626.GD7898@sasha-vm>
 <4c6d6697-b629-243c-824b-8080ee1e1635@akamai.com>
 <20190625221821.GA17994@kroah.com>
 <7282e627-edd6-51cb-ad9d-d9f34b2e9628@akamai.com>
 <20190626004846.GA21530@kroah.com> <20190626082953.GA10789@kroah.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <8a6f8dc2-f54c-592c-21d0-1d3ad733a17c@akamai.com>
Date:   Wed, 26 Jun 2019 09:28:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190626082953.GA10789@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=769
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260194
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=832 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260193
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/26/19 1:29 AM, Greg KH wrote:
> 
> Nevermind with this, in another email thread Eric provided a simpler
> patch which I have now just queued up to the stable kernel trees.
> 
> I'll probably just do a quick round of review/releases now for this
> issue as people are hitting it already.
> 

Sounds great. Thanks Eric!

Josh
