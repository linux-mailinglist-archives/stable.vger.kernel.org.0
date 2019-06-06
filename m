Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA3937340
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 13:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbfFFLoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 07:44:18 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32990 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727157AbfFFLoS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 07:44:18 -0400
Received: from LHREML712-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id B9CDA6C53C31372D7D72;
        Thu,  6 Jun 2019 12:44:15 +0100 (IST)
Received: from [10.220.96.108] (10.220.96.108) by smtpsuk.huawei.com
 (10.201.108.35) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 6 Jun
 2019 12:43:51 +0100
Subject: Re: [PATCH v3 0/2] ima/evm fixes for v5.2
To:     <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>
References: <20190606112620.26488-1-roberto.sassu@huawei.com>
From:   Roberto Sassu <roberto.sassu@huawei.com>
Message-ID: <3711f387-3aef-9fbb-1bb4-dded6807b033@huawei.com>
Date:   Thu, 6 Jun 2019 13:43:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20190606112620.26488-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.220.96.108]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/6/2019 1:26 PM, Roberto Sassu wrote:
> Previous versions included the patch 'ima: don't ignore INTEGRITY_UNKNOWN
> EVM status'. However, I realized that this patch cannot be accepted alone
> because IMA-Appraisal would deny access to new files created during the
> boot. With the current behavior, those files are accessible because they
> have a valid security.ima (not protected by EVM) created after the first
> write.
> 
> A solution for this problem is to initialize EVM very early with a random
> key. Access to created files will be granted, even with the strict
> appraisal, because after the first write those files will have both
> security.ima and security.evm (HMAC calculated with the random key).
> 
> Strict appraisal will work only if it is done with signatures until the
> persistent HMAC key is loaded.

Changelog

v2:
- remove patch 1/3 (evm: check hash algorithm passed to init_desc());
   already accepted
- remove patch 3/3 (ima: show rules with IMA_INMASK correctly);
   already accepted
- add new patch (evm: add option to set a random HMAC key at early boot)
- patch 2/3: modify patch description

v1:
- remove patch 2/4 (evm: reset status in evm_inode_post_setattr()); file
   attributes cannot be set if the signature is portable and immutable
- patch 3/4: add __ro_after_init to ima_appraise_req_evm variable
   declaration
- patch 3/4: remove ima_appraise_req_evm kernel option and introduce
   'enforce-evm' and 'log-evm' as possible values for ima_appraise=
- remove patch 4/4 (ima: only audit failed appraisal verifications)
- add new patch (ima: show rules with IMA_INMASK correctly)


> Roberto Sassu (2):
>    evm: add option to set a random HMAC key at early boot
>    ima: add enforce-evm and log-evm modes to strictly check EVM status
> 
>   .../admin-guide/kernel-parameters.txt         | 11 ++--
>   security/integrity/evm/evm.h                  | 10 +++-
>   security/integrity/evm/evm_crypto.c           | 57 ++++++++++++++++---
>   security/integrity/evm/evm_main.c             | 41 ++++++++++---
>   security/integrity/ima/ima_appraise.c         |  8 +++
>   security/integrity/integrity.h                |  1 +
>   6 files changed, 106 insertions(+), 22 deletions(-)
> 

-- 
HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Bo PENG, Jian LI, Yanli SHI
