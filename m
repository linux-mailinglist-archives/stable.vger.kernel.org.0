Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30A665F2D8
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 18:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235262AbjAERfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 12:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbjAERfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 12:35:22 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B3310555;
        Thu,  5 Jan 2023 09:35:20 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305HEqAJ007075;
        Thu, 5 Jan 2023 17:35:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=luc5WyRo2KogGJsCDxru6UV95e0RwpyQSyjG3pihxMI=;
 b=K/30oRIxJHfPfROFGTOd60N92VRl/Yaut8piY+aHCb+jd2Y3nOVQX0U+nSzSu09/4Vqt
 sbyYB6v/POJx8gx9Q3pMCOwZy6sJ/jcTfrh6qYrzzXoq/BtLzPZyt/LvUHfglv+ffGhb
 EWLSc68rnofaOWuEbkvFDj0dERn2Hno5iQsDpfAAwWTThN6KfbF3Ny0Ckd5Q/MsnlaHs
 9E5zTdEIeYOOZxGCwRlwglrYVRhSLfRZYTrYQldM05tOvVjGn28GPxunY/MJffUE9oQc
 L2Qq9B8ySwEz4//c/UJaEAUVjZqDgvuKKXZ+xCGoncwPviBaVafEDlBUlSiapwcLlvgx Jg== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx2sage1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 17:35:10 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 305GUkj2009523;
        Thu, 5 Jan 2023 17:35:09 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3mtcq7q27s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 17:35:09 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305HZ8h359834874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 17:35:08 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B5AC58055;
        Thu,  5 Jan 2023 17:35:08 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B370158043;
        Thu,  5 Jan 2023 17:35:07 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.84.210])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 17:35:07 +0000 (GMT)
Message-ID: <d11ea8036738664ec7a796d56b38f63ce0b64ae5.camel@linux.ibm.com>
Subject: Re: [PATCH v6 2/3] ima: use the lsm policy update notifier
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     GUO Zihua <guozihua@huawei.com>, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Cc:     paul@paul-moore.com, linux-integrity@vger.kernel.org,
        luhuaxin1@huawei.com
Date:   Thu, 05 Jan 2023 12:35:07 -0500
In-Reply-To: <20230105062312.14325-3-guozihua@huawei.com>
References: <20230105062312.14325-1-guozihua@huawei.com>
         <20230105062312.14325-3-guozihua@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wfRU6Bzq6Lmtn8WrfPUMoYumqcxo49_2
X-Proofpoint-ORIG-GUID: wfRU6Bzq6Lmtn8WrfPUMoYumqcxo49_2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_08,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 impostorscore=0
 mlxlogscore=858 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050139
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> +static struct ima_rule_entry *ima_lsm_copy_rule(struct ima_rule_entry *entry)
> +{
> +	struct ima_rule_entry *nentry;
> +	int i, result;
> +
> +	nentry = kmalloc(sizeof(*nentry), GFP_KERNEL);
> +	if (!nentry)
> +		return NULL;
> +
> +	/*
> +	 * Immutable elements are copied over as pointers and data; only
> +	 * lsm rules can change
> +	 */
> +	memcpy(nentry, entry, sizeof(*nentry));
> +	memset(nentry->lsm, 0, FIELD_SIZEOF(struct ima_rule_entry, lsm));
> +
>  	for (i = 0; i < MAX_LSM_RULES; i++) {
> -		security_filter_rule_free(entry->lsm[i].rule);
> -		kfree(entry->lsm[i].args_p);
> +		if (!entry->lsm[i].rule)
> +			continue;
> +
> +		nentry->lsm[i].type = entry->lsm[i].type;
> +		nentry->lsm[i].args_p = kstrdup(entry->lsm[i].args_p,
> +						GFP_KERNEL);
> +		if (!nentry->lsm[i].args_p)
> +			goto out_err;
> +
> +		result = security_filter_rule_init(nentry->lsm[i].type,
> +						   Audit_equal,
> +						   nentry->lsm[i].args_p,
> +						   &nentry->lsm[i].rule);
> +		if (result == -EINVAL)
> +			pr_warn("ima: rule for LSM \'%d\' is undefined\n",
> +				entry->lsm[i].type);
>  	}
> +	return nentry;
> +
> +out_err:
> +	ima_lsm_free_rule(entry);
>  	kfree(entry);

This should be "nentry".   Otherwise, it looks good.

thanks,

Mimi

> +	return NULL;
> +}

