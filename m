Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA122E8E0B
	for <lists+stable@lfdr.de>; Sun,  3 Jan 2021 21:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbhACUNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jan 2021 15:13:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42800 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726920AbhACUNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jan 2021 15:13:37 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 103K1nnV062369;
        Sun, 3 Jan 2021 15:12:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=4XHrZhDIqp8yekC4mBs+reAV3XTLBXRrtgGasO1mmoI=;
 b=blEAguGbwtvkEpnTwPJ4LZgMzTjuq58xrhT5GY54r4rNGMfqfXcrLT5Am4xfOlUGbjEN
 s9TG/dN7tvukiC/mdYZz6imAya0sBwhWs1vCn720uX8k787S+Egx0dTQfSgJeWzDeIli
 NG2PLA0Blptf5Q44DxKRKgMcB3QAIPuwbyo+JyNsF/249ZMoWMQ1m2n/RDKC1QX7V9Ww
 Kldsx1hCiuyQ7l8tDbyyFLUzSRHG/tLNqwwLQKp3eSysNpj989YmUy6uf/N1zpMa/iNB
 fIeZ+BBtrgVlNgw2ubooTUPORKAY83o4fb3AuXBcmESUnyCAgqKR20SkYgyE8OWFM4hD Bg== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35um5c0feq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 Jan 2021 15:12:43 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 103KBTiT014903;
        Sun, 3 Jan 2021 20:12:42 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01dal.us.ibm.com with ESMTP id 35tgf8v0ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 03 Jan 2021 20:12:42 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 103KCf4P29229468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 3 Jan 2021 20:12:41 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 895F47805C;
        Sun,  3 Jan 2021 20:12:41 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E31578060;
        Sun,  3 Jan 2021 20:12:38 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.85.172.80])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun,  3 Jan 2021 20:12:38 +0000 (GMT)
Message-ID: <7652dab94febc8667c34996740be43ff75fccdc4.camel@linux.ibm.com>
Subject: Re: [PATCH 2/3] scsi: megaraid_sas: check user-provided offsets
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Phil Oester <kernel@linuxace.com>, Arnd Bergmann <arnd@arndb.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Sun, 03 Jan 2021 12:12:36 -0800
In-Reply-To: <CAK8P3a1kmoBeBM3Nk=VigR-CnN8c2HKC8eubrvLt1TpD7gsAHw@mail.gmail.com>
References: <20200908213715.3553098-1-arnd@arndb.de>
         <20200908213715.3553098-2-arnd@arndb.de>
         <20201231001553.GB16945@home.linuxace.com>
         <CAK8P3a0_WORgd4Wvd3n+59oR=-rrESwg_MgpDJN4xPo_e6ir5Q@mail.gmail.com>
         <739a3639944f099a76d145eb119b77701f13444d.camel@linux.ibm.com>
         <CAK8P3a1kmoBeBM3Nk=VigR-CnN8c2HKC8eubrvLt1TpD7gsAHw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-03_11:2020-12-31,2021-01-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 mlxlogscore=696 malwarescore=0 priorityscore=1501 phishscore=0
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101030125
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2021-01-03 at 19:49 +0100, Arnd Bergmann wrote:
> On Sun, Jan 3, 2021 at 6:00 PM James Bottomley <jejb@linux.ibm.com>
> wrote:
> > On Sun, 2021-01-03 at 17:26 +0100, Arnd Bergmann wrote:
> > [...]
> > > @@ -8209,7 +8208,7 @@ megasas_mgmt_fw_ioctl(struct
> > > megasas_instance
> > > *instance,
> > >                 if (instance->consistent_mask_64bit)
> > >                         put_unaligned_le64(sense_handle,
> > > sense_ptr);
> > >                 else
> > > -                       put_unaligned_le32(sense_handle,
> > > sense_ptr);
> > > +                       put_unaligned_le64(sense_handle,
> > > sense_ptr);
> > >         }
> > 
> > This hunk can't be right.  It effectively means removing the if.
> 
> I'm just trying to restore the state before the regression introduced
> in my 381d34e376e3 ("scsi: megaraid_sas: Check user-provided
> offsets").
> 
> The old code always stored 'sizeof(long)' bytes into sense_ptr,
> regardless of instance->consistent_mask_64bit, but it would truncate
> the address to 32 bit if that was cleared. This was clearly bogus
> and I tried to make it do something more meaningful, only storing
> 8 bytes into the structure if it was configured for 64-bit DMA,
> regardless of the capabilities of the kernel.

Heh, well, all this depends on how the firmware interprets the pointer,
for which we don't seem to have a manual.  Instinct tells me the flag
MFI_FRAME_SENSE64 is what does this and that's conditioned on the same
if clause 100 lines above this, so the fix your proposing would still
seem to be wrong, because I think when that flag is not set, the device
expects the sense pointer to be 32 bit.

> > However, the if is needed because sense_handle is a dma_addr_t
> > which can be either 32 or 64 bit.  What about changing the if to
> > 
> > if (sizeof(dma_addr_t) == 8)
> > 
> > instead?
> 
> That would not be useful either, the device surely does not care
> if the kernel supports 64-bit DMA. What we'd really need here is
> someone with access to the interface specifications to see how
> many bytes should be stored in the structure. I suspect always
> storing 64 bits (as my patch does) is correct, and would send a
> proper patch to remove the if() if Phil confirms that my test
> patch fixes the regression.

Well, as I said above, I'm speculating the device does what we tell it,
and whether to use 32 or 64 bits for the sense pointer definitely seems
to be a flag the driver controls ... we really need someone with access
to the programming manual to tell us if this speculation is accurate,
though.

James


