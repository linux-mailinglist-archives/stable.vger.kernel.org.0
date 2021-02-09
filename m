Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5CF31576B
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 21:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhBIUEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 15:04:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233450AbhBITve (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 14:51:34 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119JXGqO091331;
        Tue, 9 Feb 2021 14:49:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=1gsPEt1/kDSSNflaImtKJVxcfOurcbBEdIG2t/N6F+8=;
 b=mo+TQXicVlL/ceoR6QmzmGuRiUkrHwCF1KsxgqYAJQWrKD+UkaBvCChXGlipYOdUFzAh
 8qkjbA2CftXI3LIIEvrwHmnLOrvMqWq+YarhtAiOYg0KccnnQFp7YRUB+UPJF7f57qlP
 EkNi+zmDwkCJs6eeSxf3QxcFGu37CAwHs+lVfCAzUy75jzczXTJNTd7tx5TDKqNlj7q9
 QXqUMcfnDb3LjFcvRu/3v6qJenNgZNWTkVyja1ed9raALR4QHow8UeQVBo9DoEvzpfaz
 cHhqRBhSBz9PNqbjgCRNdy9U/bUr9F8A4bpohK1sjXG6++3PxRNVVuea0C3zKMWCuNlj sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36kyx7t8na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 14:49:01 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119JXKuf091898;
        Tue, 9 Feb 2021 14:49:00 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36kyx7t8n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 14:49:00 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119Jgdpc003984;
        Tue, 9 Feb 2021 19:49:00 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 36hjr9f50u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 19:49:00 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119JmxOf42729850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 19:48:59 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E4C6B2065;
        Tue,  9 Feb 2021 19:48:59 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E612B205F;
        Tue,  9 Feb 2021 19:48:58 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com.com (unknown [9.85.203.235])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 19:48:58 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        kwankhede@nvidia.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, pasic@linux.vnet.ibm.com,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: [PATCH 0/1] fix circular lockdep when staring SE guest
Date:   Tue,  9 Feb 2021 14:48:29 -0500
Message-Id: <20210209194830.20271-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_06:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1011
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090094
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch f21916ec4826 ("s390/vfio-ap: clean up vfio_ap resources when KVM
pointer invalidated") introduced a change that results in a circular
locking dependency when a Secure Execution guest that is configured with
crypto devices is started. The problem resulted due to the fact that the
patch moved the setting of the guest's AP masks within the protection of
the matrix_dev->lock when the vfio_ap driver is notified that the KVM 
pointer has been set. Since it is not critical that setting/clearing of
the guest's AP masks when the driver is notified, the masks will not be
updated under the matrix_dev->lock. The lock is necessary for the
setting/unsetting of the KVM pointer, however, so that will remain in
place. 

The dependency chain for the circular lockdep resolved by this patch 
is:

#2	vfio_ap_mdev_group_notifier:	kvm->lock
					matrix_dev->lock

#1:	handle_pqap:			matrix_dev->lock
	kvm_vcpu_ioctl:			vcpu->mutex

#0:	kvm_s390_cpus_to_pv:		vcpu->mutex
	kvm_vm_ioctl:  			kvm->lock   

Tony Krowiak (1):
  s390/vfio-ap: fix circular lockdep when setting/clearing crypto masks

 drivers/s390/crypto/vfio_ap_ops.c | 75 ++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 30 deletions(-)

-- 
2.21.1

