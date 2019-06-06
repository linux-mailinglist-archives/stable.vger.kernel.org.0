Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D644372D7
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 13:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfFFL3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 07:29:35 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32987 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727034AbfFFL3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 07:29:35 -0400
Received: from lhreml705-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id BDD6AA80612E5B3DBD10;
        Thu,  6 Jun 2019 12:29:32 +0100 (IST)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.154)
 by smtpsuk.huawei.com (10.201.108.46) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 6 Jun 2019 12:29:23 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <dmitry.kasatkin@huawei.com>,
        <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v3 0/2] ima/evm fixes for v5.2
Date:   Thu, 6 Jun 2019 13:26:18 +0200
Message-ID: <20190606112620.26488-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.154]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Previous versions included the patch 'ima: don't ignore INTEGRITY_UNKNOWN
EVM status'. However, I realized that this patch cannot be accepted alone
because IMA-Appraisal would deny access to new files created during the
boot. With the current behavior, those files are accessible because they
have a valid security.ima (not protected by EVM) created after the first
write.

A solution for this problem is to initialize EVM very early with a random
key. Access to created files will be granted, even with the strict
appraisal, because after the first write those files will have both
security.ima and security.evm (HMAC calculated with the random key).

Strict appraisal will work only if it is done with signatures until the
persistent HMAC key is loaded.


Roberto Sassu (2):
  evm: add option to set a random HMAC key at early boot
  ima: add enforce-evm and log-evm modes to strictly check EVM status

 .../admin-guide/kernel-parameters.txt         | 11 ++--
 security/integrity/evm/evm.h                  | 10 +++-
 security/integrity/evm/evm_crypto.c           | 57 ++++++++++++++++---
 security/integrity/evm/evm_main.c             | 41 ++++++++++---
 security/integrity/ima/ima_appraise.c         |  8 +++
 security/integrity/integrity.h                |  1 +
 6 files changed, 106 insertions(+), 22 deletions(-)

-- 
2.17.1

