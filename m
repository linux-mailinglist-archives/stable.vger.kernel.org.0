Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95C147CC5B
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 05:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239016AbhLVExO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 23:53:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9712 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238901AbhLVExO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 23:53:14 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BM3c9SP023088;
        Wed, 22 Dec 2021 04:53:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=HMEZx50apQ8KyK9Eph2UXaepMIh1xcQpXKBV7MZuHVw=;
 b=ngS6lpa+rXWeGpSvVZMnMlONphyh4gDKQc6zb1wpMHGFiBpsV5h2RbWEJjgLBDDCrBDS
 9O1l9cY4ays71/joYGWyiUEcPTxWWdXGccOwDXbf9Qp3qr2ylwBmogqXNrdlNOLY2O7q
 Hq7cI1d/fte2LZlV5GR6Sj/TeyfhrELj1ERa3taP6Llp+kNNbaaJ9M2HVMrmcTdYYF0z
 aHbrDrmVEP/7q88D/y9lbT/jG3Tx7CK4uAuR/IbvXpHNM8cQDklRxH9DFcmpJ3GVGekx
 PsGMy+biPYi+ME02jqpg8NhPa4YsJXcIqm/JAPsLMjBpkqwrtbVMx+NG9TGaMkZFi1/d 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d3asw57st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Dec 2021 04:53:08 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BM4pQmN014199;
        Wed, 22 Dec 2021 04:53:07 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d3asw57sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Dec 2021 04:53:07 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BM4qnVt023015;
        Wed, 22 Dec 2021 04:53:06 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 3d179bdvpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Dec 2021 04:53:06 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BM4r5k021692840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Dec 2021 04:53:06 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A160CAC06C;
        Wed, 22 Dec 2021 04:53:05 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 800B6AC060;
        Wed, 22 Dec 2021 04:53:05 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 22 Dec 2021 04:53:05 +0000 (GMT)
Message-ID: <af847879-0f29-08e7-7609-da3b27381d3a@linux.ibm.com>
Date:   Tue, 21 Dec 2021 23:53:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2] tpm: fix potential NULL pointer access in
 tpm_del_char_device
Content-Language: en-US
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jarkko@kernel.org, jgg@ziepe.ca
Cc:     p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20211220150635.8545-1-LinoSanfilippo@gmx.de>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20211220150635.8545-1-LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: N-oZVJNJQKRdDZiBYWgit4_wwokNBnlE
X-Proofpoint-GUID: cmrkyqp66uVOjVgGeC79IWzMdcCo6e6j
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-22_01,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 impostorscore=0 clxscore=1011 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112220028
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/20/21 10:06, Lino Sanfilippo wrote:
> Some SPI controller drivers unregister the controller in the shutdown
> handler (e.g. BCM2835). If such a controller is used with a TPM 2 slave
> chip->ops may be accessed when it is already NULL:
>
> At system shutdown the pre-shutdown handler tpm_class_shutdown() shuts down
> TPM 2 and sets chip->ops to NULL. Then at SPI controller unregistration
> tpm_tis_spi_remove() is called and eventually calls tpm_del_char_device()
> which tries to shut down TPM 2 again. Thereby it accesses chip->ops again:
> (tpm_del_char_device calls tpm_chip_start which calls tpm_clk_enable which
> calls chip->ops->clk_enable).
>
> Avoid the NULL pointer access by testing if chip->ops is valid and skipping
> the TPM 2 shutdown procedure in case it is NULL.
>
> Fixes: dcbeab1946454 ("tpm: fix crash in tpm_tis deinitialization")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---
>
> Changes to v2:
> - rephrased the commit message to clarify the circumstances under which
>    this bug triggers (as requested by Jarkko)
>
>
> I was able to reproduce this issue with a SLB 9670 TPM chip controlled by
> a BCM2835 SPI controller.
>
> The approach to fix this issue in the BCM2835 driver was rejected after a
> discussion on the mailing list:
>
> https://marc.info/?l=linux-integrity&m=163285906725367&w=2
>
> The reason for the rejection was the realization, that this issue should rather
> be fixed in the TPM code:
>
> https://marc.info/?l=linux-spi&m=163311087423271&w=2
>
> So this is the reworked version of a patch that is supposed to do that.
>
>
>   drivers/char/tpm/tpm-chip.c | 16 +++++++++++-----
>   1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index ddaeceb7e109..7960da490e72 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -474,13 +474,19 @@ static void tpm_del_char_device(struct tpm_chip *chip)
>   
>   	/* Make the driver uncallable. */
>   	down_write(&chip->ops_sem);
> -	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> -		if (!tpm_chip_start(chip)) {
> -			tpm2_shutdown(chip, TPM2_SU_CLEAR);
> -			tpm_chip_stop(chip);
> +	/* Check if chip->ops is still valid: In case that the controller
> +	 * drivers shutdown handler unregisters the controller in its
> +	 * shutdown handler we are called twice and chip->ops to NULL.
> +	 */
> +	if (chip->ops) {
> +		if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> +			if (!tpm_chip_start(chip)) {
> +				tpm2_shutdown(chip, TPM2_SU_CLEAR);
> +				tpm_chip_stop(chip);
> +			}
>   		}
> +		chip->ops = NULL;
>   	}
> -	chip->ops = NULL;
>   	up_write(&chip->ops_sem);
>   }
>   
>
> base-commit: a7904a538933c525096ca2ccde1e60d0ee62c08e


Fixes: 39d0099f9439 ("powerpc/pseries: Add shutdown() to vio_driver and 
vio_bus")

Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>

Tested-by: Stefan Berger <stefanb@linux.ibm.com>


