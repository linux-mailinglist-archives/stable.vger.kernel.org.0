Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB98351FBA9
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 13:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbiEILt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 07:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiEILtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 07:49:24 -0400
Received: from smtp2.infineon.com (smtp2.infineon.com [IPv6:2a00:18f0:1e00:4::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CB81C9676;
        Mon,  9 May 2022 04:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1652096730; x=1683632730;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kMygQDKRp1jGxPYCSiZeHi1ypIZtJR5d8kJ5nHlpwjU=;
  b=Z2c0I/6XouSn1o5P6QYUEwEIwyrBvPJlpY/RrP+7qeeHSqadZmMHKy7G
   xOstDVLrNwDpTy7LCMMiqiKg2OdvledfnKdHwCoUJllDVekU4S7xJqORT
   QgBvIsjSZt3XUnw7+MwExQlPnsEI+HuKwKfWdlerAZmvwyGKoe7DN+6zp
   I=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10341"; a="176637034"
X-IronPort-AV: E=Sophos;i="5.91,211,1647298800"; 
   d="scan'208";a="176637034"
Received: from unknown (HELO mucxv001.muc.infineon.com) ([172.23.11.16])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 13:45:28 +0200
Received: from MUCSE822.infineon.com (MUCSE822.infineon.com [172.23.29.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv001.muc.infineon.com (Postfix) with ESMTPS;
        Mon,  9 May 2022 13:45:28 +0200 (CEST)
Received: from MUCSE818.infineon.com (172.23.29.44) by MUCSE822.infineon.com
 (172.23.29.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 13:45:27 +0200
Received: from smaha-lin-dev01.agb.infineon.com (172.23.8.247) by
 MUCSE818.infineon.com (172.23.29.44) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 9 May 2022 13:45:27 +0200
From:   Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
To:     <jarkko@kernel.org>
CC:     <Marten.Lindahl@axis.com>, <jgg@ziepe.ca>,
        <johannes.holland@infineon.com>, <jsnitsel@redhat.com>,
        <linux-integrity@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <martenli@axis.com>, <nayna@linux.vnet.ibm.com>,
        <peterhuewe@gmx.de>, <stable@vger.kernel.org>,
        <stefan.mahnke-hartmann@infineon.com>
Subject: Re: [PATCH 1/2] tpm: Fix buffer access in tpm2_get_tpm_pt()
Date:   Mon, 9 May 2022 13:48:09 +0200
Message-ID: <20220509114809.245621-1-stefan.mahnke-hartmann@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YnbL2R/a3SwA3fMC@iki.fi>
References: <YnbL2R/a3SwA3fMC@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE823.infineon.com (172.23.29.54) To
 MUCSE818.infineon.com (172.23.29.44)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07.05.22 21:43, Jarkko Sakkinen wrote:
> On Fri, May 06, 2022 at 02:31:46PM +0200, Stefan Mahnke-Hartmann wrote:
>> Under certain conditions uninitialized memory will be accessed.
>> As described by TCG Trusted Platform Module Library Specification,
>> rev. 1.59 (Part 3: Commands), if a TPM2_GetCapability is received,
>> requesting a capability, the TPM in Field Upgrade mode may return a
>                                       ~~~~~~~~~~~~~~~~~~
>
> Looks like random picks for casing: two words with upper case letter and
> one with lowe case.

In the TCG specification it is unfortunately also inconsistent.
I will change it to lower case then.

>
>> zero length list.
>> Check the property count in tpm2_get_tpm_pt().
>>
>> Fixes: 2ab3241161b3 ("tpm: migrate tpm2_get_tpm_pt() to use struct tpm_buf")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Stefan Mahnke-Hartmann <stefan.mahnke-hartmann@infineon.com>
>
> Which section is this in that specification documented?

It is described in the TCG Trusted Platform Module Library Specification,
rev. 1.59 (Part 3: Commands) in Chapter 30.2.1, Example 3. This example
describes the behavior in failure mode, but it may occur in other
circumstances, such as field upgrade mode.

>
> I looked into section 30.2 but could not find the part that documents this
> behaviour, i.e. returning success in FW upgrade mode. Why it wouldn't just
> return TPM_RC_UPGRADE?

Since some computer system failed booting up in case the TPM returned
anything else than SUCCESS, therefore Infineon decided to return SUCCESS
when TPM is in field upgrade mode.

BR, Stefan

>
> BR, Jarkko
>
>  

