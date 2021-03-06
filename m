Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F52A32FBB3
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 17:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhCFQHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 11:07:54 -0500
Received: from mout.gmx.net ([212.227.15.18]:34725 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbhCFQH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Mar 2021 11:07:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1615046831;
        bh=Cr0y1Ijk/imTnZhkOwKCYwktS1OmcFoCqG4NV+oT/WY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=VxTzhtdEvbkgGngdLXLmw7xxvyC9nvFKB00C0eIHJOSkMH2MG20XgrvuZl+TUrmIM
         r7RySqaxIoPZBYGGSKu3AfWvThDXOUTiALFIXQDQ3y5KTg7NXTTCSZ03cepV0jDsWE
         5gJLkAT1IRyJHfEAEK/AQs23o4jmHIecwv9xaVL8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([78.42.220.31]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MrhQ6-1m5utn136y-00nidY; Sat, 06
 Mar 2021 17:07:11 +0100
Subject: Re: [PATCH v3 2/2] tpm: in tpm2_del_space check if ops pointer is
 still valid
To:     Lino Sanfilippo <l.sanfilippo@kunbus.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        peterhuewe@gmx.de, jarkko@kernel.org
Cc:     jgg@ziepe.ca, stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-3-git-send-email-LinoSanfilippo@gmx.de>
 <7308e5e9f51501bd92cced8f28ff6130c976b3ed.camel@HansenPartnership.com>
 <327f4c87-e652-6cbe-c624-16a6edf0c31d@kunbus.com>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
Message-ID: <1d508dc0-7999-86fb-1321-7fd8ec5b6ff7@gmx.de>
Date:   Sat, 6 Mar 2021 17:07:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <327f4c87-e652-6cbe-c624-16a6edf0c31d@kunbus.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0quViwEoF2SBr4MDlpw8cEmGb+RKhKlODmdMTnRfXjr4hfZ48/a
 3U7YeBrwSpcfK9Gd76dimI7+hhfK2CunbgOMk4JLIivhjsMVUsyKboh3C2Hzti2YuG8WAcO
 mGpIMIPS7RRDA51xJx41Yv4pCzwxQJ+tlL8QGLV7i2ChzUczcSct1Hr+eMIoU0CMuMvqdg4
 SdfYNQqto5RXxfBVSe0Sg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3QrcFkXfcas=:OoiaUYjKzoLlDG/lDqpVA/
 iD4i72yPlwKVN5ykQl00J1m2stLX5PkTy+oWW0EnbVBCzdCnJ9u164wI1TQFP3i+slD1znQU/
 +02SudoEYo69qi9f6jD4PQmXtCn2AhFcUD/6ZC8xKjCx9AvU9Q2oAXt3sCzog/9zpbxCvSLJZ
 kUo+DOYhaelJg8fsTyNtYHDncZVDR8AUwtXo1wn/pmFu5BGQJsiIrSgc3vwZyWo+lHFUo+Z1u
 jO3LpuJ+QsQVp5oqVwQxD2Azb3UtUUcNwWSywncTrxARmYBJTFNv778z4lH1LSDyBksGpql2X
 u1eWjYykCKBrvFET4Hfx6G7NLfPh3wah3JkOH72bdj9ADkM9/Y43nPs1n6FbXEUKc/VT6i4Zo
 yAAQxcGSUaKyMiQjvR5yZWslo+6+p+m330Szl2q7loufrv9/LLmoCjfdnPpxEQYegETPinjhj
 gU224R4WJDQyIeJEqX9g+nvCWO4ft3oX6EWC3F4vXrjU3aCdn+AwB3PdNaHjQNwmIh9HNglWl
 B+nutmwKTa+unxej9U9vvwYIh/FdZs6O6lD/jus2qggOPnjJJWOOgzQX5dXkeBXMRP467aa17
 xu8VzUrOy0kkG2sweVseWBA1iTLV+/05UOJr2q8ykFHiNOtBD7C7zArABiEy0OhntDStfc/cH
 f1ArlN1ajFzN/IfW39ubJ8NdVPSuAnlW1k863AjMjiIBDdI5hFci1MFzFAhxv77Nr9xyO59Oz
 wlJQYe1uhTfrBBKhZ1t4GhzQi/6Eu9z19obSUWMciB7FHsI6usKigLWuXfgD6CZGf3YL6k2BY
 ezzzyORneM8aOEGEf64oVHpLvb9ftIUMUt8+hzfXSUR4XFWKNT6GViOAHGCXoGMsuewstv3Ac
 fWWcwBBfYcXJRPSXP2WQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi James,

> On 05.02.21 01:34, James Bottomley wrote:
>> The reporter went silent before we could get this tested, but could you
>> try, please, because your patch is still hand rolling the ops get/put,
>> just slightly better than it had been done previously.
>
> I tested your patch and it fixes the issue. Your solution seems indeed m=
uch cleaner.
>
> FWIW:
>
> Tested-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
>

Are you going to send a patch for this? As stated above I verified that yo=
ur
solution fixes the issue.

Best regards,
Lino
