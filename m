Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174643D8D6F
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 14:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbhG1MF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 08:05:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58128 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234835AbhG1MFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 08:05:25 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SC2Wcx102161;
        Wed, 28 Jul 2021 08:05:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=aDjoQ6PCd+ro0kecpAZRm+2oFswZI14RrcJfPOq+DS8=;
 b=RuJbATXb873pUUrRb6xKR6yAyaMOzfNG/pnRZvs2Z2gSHL+FYsTquIQu3shSJ+baxZPD
 aSVxA2S0shsQOIMJWzBN2/uQA2m059Ji78hr6bqmxvtGhx6ZtdixPM4X2/8KkKh+wICN
 8rW4HZfIkMUqFiwieqtP2aB0rtmxImZkdv5tvUE2lfTFP3py6VPd8owzzR+8qCPwUAWg
 oCWTr9Cq5s++wroNPBQ2BVgxJz246CukuCXqdSyzu2YDUbmMaB2kHG5qC+qQRjrqqYdP
 pS8uAc65qtF3VmWCFt1u6N/PAJuEPXt2GztL9PamnawAXxSfD5dVuPULnScJz2JJ5JyA Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a36g897ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 08:05:11 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SC2jZu103800;
        Wed, 28 Jul 2021 08:05:10 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a36g897d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 08:05:10 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SC2enw028535;
        Wed, 28 Jul 2021 12:05:07 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3a235prnpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 12:05:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SC55iL27459932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 12:05:05 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A88111C04C;
        Wed, 28 Jul 2021 12:05:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EE4711C052;
        Wed, 28 Jul 2021 12:05:02 +0000 (GMT)
Received: from pratiks-thinkpad.ibmuc.com (unknown [9.85.80.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 12:05:01 +0000 (GMT)
From:   "Pratik R. Sampat" <psampat@linux.ibm.com>
To:     mpe@ellerman.id.au, rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, psampat@linux.ibm.com,
        pratik.r.sampat@gmail.com
Subject: [PATCH v2 0/1] cpufreq:powernv: Fix init_chip_info initialization in numa=off
Date:   Wed, 28 Jul 2021 17:34:59 +0530
Message-Id: <20210728120500.87549-1-psampat@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qLF8gRZNsat2QJgIsydJHKnL5EJaRZen
X-Proofpoint-ORIG-GUID: 79Iav9C0fPQN7vYJm35dA6APE-PsZyRf
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_07:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 impostorscore=0 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280068
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v1: https://lkml.org/lkml/2021/7/26/1509
Changelog v1-->v2:
Based on comments from Gautham,
1. Included a #define for MAX_NR_CHIPS instead of hardcoding the
allocation.

Pratik R. Sampat (1):
  cpufreq:powernv: Fix init_chip_info initialization in numa=off

 drivers/cpufreq/powernv-cpufreq.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

-- 
2.31.1

