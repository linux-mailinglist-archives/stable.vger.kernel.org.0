Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B2B4117C4
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 17:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbhITPIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 11:08:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21124 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234857AbhITPIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 11:08:01 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KEstcC004747;
        Mon, 20 Sep 2021 11:06:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=TwRvPekDDJoXGB/PKjSgwn63N2whwnXRm3mTsfhMsD0=;
 b=hlNi9WXQu7lYMvFqMHcJ5wzr1uYwlgRn4Iw+njeU6MJ6Md1B5kk0GNY+aicd+jPSz+0y
 rA/2JVyL8k2n4ZTWm1NFmfbMp4PVrDgumS6iw08AZeDQmk01NYab8opLm4u3in93wFKQ
 dlv/ClZHlTsfCGLfY/+3OnS/E9M8uwNpkUxgdvjZBcPDDAaZIbNyxvXIin2PwRvNsaAq
 d4E8N9yIkX64rnu8A1C4wUQTyGZSTnSHpcWlp8UC0rx0nfH/4KojLlALEX6V8tdcmPtJ
 jid1kO33NyACRjFJ6sq7zk8F3HiojhzI2Ws05f3OUb25MwEGUGmMaSkK/MSTHTxIDyGW WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b5wa1aegp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 11:06:33 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KEvp9r016352;
        Mon, 20 Sep 2021 11:06:33 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b5wa1aeft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 11:06:32 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KF36gq001999;
        Mon, 20 Sep 2021 15:06:31 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3b57r8j2r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 15:06:31 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KF6Rpr41222492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 15:06:27 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 619F15204F;
        Mon, 20 Sep 2021 15:06:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 55DEB52078;
        Mon, 20 Sep 2021 15:06:27 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id EFD96E18F4; Mon, 20 Sep 2021 17:06:26 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     gregkh@linuxfoundation.org, KVM <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: [PATCH 0/1] KVM: s390: backport for stable of "KVM: s390: index
Date:   Mon, 20 Sep 2021 17:06:15 +0200
Message-Id: <20210920150616.15668-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1-ySJq7-cdHjJL8EsKAvEAgeeCwxkUCO
X-Proofpoint-GUID: eFYG-Hu2mfFfqYne1IfnbS_W_W9ZqHG2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 suspectscore=0
 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=603 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109200097
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stable team,

here is a backport for 4.19 of
commit a3e03bc1368 ("KVM: s390: index kvm->arch.idle_mask by vcpu_idx")
This basically removes the kick_mask parts that were introduced with
kernel 5.0 and fixes up the location of the idle_mask to the older
place.

FWIW, it might be a good idea to also backport
8750e72a79dd ("KVM: remember position in kvm->vcpus array") to avoid
a performance regression for large guests (many vCPUs) when this patch
is applied. 
@Paolo Bonzini, would you be ok with 8750e72a79dd in older stable releases?



Halil Pasic (1):
  KVM: s390: index kvm->arch.idle_mask by vcpu_idx

 arch/s390/kvm/interrupt.c | 4 ++--
 arch/s390/kvm/kvm-s390.h  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.31.1

