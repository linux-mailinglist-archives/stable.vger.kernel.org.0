Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0271C55BB6
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 00:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFYWyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 18:54:02 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:28932 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726086AbfFYWyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 18:54:02 -0400
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5PMqmLL024799;
        Tue, 25 Jun 2019 23:53:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=0IQpthYaYN6r1eamruCrfuUSCKm/oQ3bdpapAvtJO2E=;
 b=C6hyhkIT18AzEhL7+npgax2WtEHpM6erw4wzVGMWeIi0OJShptzaAP7oDdp3zrQmVmyl
 bx2jOaHDaMf2nB8WyexalyE3pBdFbb9i638wYThOLk7F7N1rO+fy4lFawZ1K82L0WmLV
 HvGArTz3WReJQaxCsMJ9wVwxpog1BeVnz/zf6/Z3auKKoUqNnVWVpy63QtQiecn2meiA
 ufTp+xKpSOGVmplh0RPNfsBhzvUemfuTbKxI939gLYpxbimQva1+a0DQqgNfweDdjSfm
 sSym9FH2Y1B1aoPmjBGiVZx2Af7HpmFRk/fUaTDmo1zYHoAUch9k+36yVnRjfsKFJZbb Og== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2tbcndb8ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 23:53:58 +0100
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x5PMlgS0000360;
        Tue, 25 Jun 2019 18:53:58 -0400
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint2.akamai.com with ESMTP id 2t9fnwnfdg-1;
        Tue, 25 Jun 2019 18:53:57 -0400
Received: from [0.0.0.0] (caldecot.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id 859C22006D;
        Tue, 25 Jun 2019 22:53:38 +0000 (GMT)
Subject: Re: [PATCH 4.14] tcp: refine memory limit test in tcp_fragment()
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, edumazet@google.com,
        stable@vger.kernel.org, jbaron@akamai.com
References: <1561483177-30254-1-git-send-email-johunt@akamai.com>
 <20190625202626.GD7898@sasha-vm>
 <4c6d6697-b629-243c-824b-8080ee1e1635@akamai.com>
 <20190625224050.GE7898@sasha-vm>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <d2272406-e751-4e80-a2e0-9ad669edfc92@akamai.com>
Date:   Tue, 25 Jun 2019 15:53:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625224050.GE7898@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250183
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250184
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/25/19 3:40 PM, Sasha Levin wrote:
> On Tue, Jun 25, 2019 at 01:29:35PM -0700, Josh Hunt wrote:
>> On 6/25/19 1:26 PM, Sasha Levin wrote:
>>> On Tue, Jun 25, 2019 at 01:19:37PM -0400, Josh Hunt wrote:
>>>> Backport of dad3a9314ac95dedc007bc7dacacb396ea10e376:
>>>
>>> You probably meant b6653b3629e5b88202be3c9abc44713973f5c4b4 here.
>>
>> I wasn't sure if I should reference the upstream commit or stable 
>> commit. dad3a9314 is the version of the commit from linux-4.14.y. 
>> There may be a similar issue with the Fixes tag below since that also 
>> references the 4.14 vers of the change.
> 
> We try to just reference upstream commits when possible. I can edit
> these if this patch will be merged.

Thanks for the help. I'll remember for next time :)

Josh
