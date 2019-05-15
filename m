Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5D41F218
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729866AbfEOLMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729860AbfEOLMp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:12:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8909221473;
        Wed, 15 May 2019 11:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918765;
        bh=xPq1L4OksLQQI+YZVQrgK+vGxv21gAcgeRbV9wvaHUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gag4AYjIh/TULm2eeAUcAdlDY8f231MQXi/y5dnSJVrr5TGFNVfjSALeO4Svok/wW
         tz4P+jiGOjwBBjdrZw8l3hZ0UhqgUHglSUsqTVpdjm2NCaQEc1JsBinbRZqbFqBX/m
         KzHnWwJhC4mgFXtwpDjV894tc/DlRBQrN3SKhTvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tyler Hicks <tyhicks@canonical.com>,
        Jon Masters <jcm@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 250/266] x86/mds: Add MDSUM variant to the MDS documentation
Date:   Wed, 15 May 2019 12:55:57 +0200
Message-Id: <20190515090731.472397331@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: speck for Pawan Gupta <speck@linutronix.de>

commit e672f8bf71c66253197e503f75c771dd28ada4a0 upstream.

Updated the documentation for a new CVE-2019-11091 Microarchitectural Data
Sampling Uncacheable Memory (MDSUM) which is a variant of
Microarchitectural Data Sampling (MDS). MDS is a family of side channel
attacks on internal buffers in Intel CPUs.

MDSUM is a special case of MSBDS, MFBDS and MLPDS. An uncacheable load from
memory that takes a fault or assist can leave data in a microarchitectural
structure that may later be observed using one of the same methods used by
MSBDS, MFBDS or MLPDS. There are no new code changes expected for MDSUM.
The existing mitigation for MDS applies to MDSUM as well.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Reviewed-by: Jon Masters <jcm@redhat.com>
[bwh: Backported to 4.4: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/hw-vuln/mds.rst |    5 +++--
 Documentation/x86/mds.rst     |    5 +++++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/Documentation/hw-vuln/mds.rst
+++ b/Documentation/hw-vuln/mds.rst
@@ -32,11 +32,12 @@ Related CVEs
 
 The following CVE entries are related to the MDS vulnerability:
 
-   ==============  =====  ==============================================
+   ==============  =====  ===================================================
    CVE-2018-12126  MSBDS  Microarchitectural Store Buffer Data Sampling
    CVE-2018-12130  MFBDS  Microarchitectural Fill Buffer Data Sampling
    CVE-2018-12127  MLPDS  Microarchitectural Load Port Data Sampling
-   ==============  =====  ==============================================
+   CVE-2019-11091  MDSUM  Microarchitectural Data Sampling Uncacheable Memory
+   ==============  =====  ===================================================
 
 Problem
 -------
--- a/Documentation/x86/mds.rst
+++ b/Documentation/x86/mds.rst
@@ -12,6 +12,7 @@ on internal buffers in Intel CPUs. The v
  - Microarchitectural Store Buffer Data Sampling (MSBDS) (CVE-2018-12126)
  - Microarchitectural Fill Buffer Data Sampling (MFBDS) (CVE-2018-12130)
  - Microarchitectural Load Port Data Sampling (MLPDS) (CVE-2018-12127)
+ - Microarchitectural Data Sampling Uncacheable Memory (MDSUM) (CVE-2019-11091)
 
 MSBDS leaks Store Buffer Entries which can be speculatively forwarded to a
 dependent load (store-to-load forwarding) as an optimization. The forward
@@ -38,6 +39,10 @@ faulting or assisting loads under certai
 exploited eventually. Load ports are shared between Hyper-Threads so cross
 thread leakage is possible.
 
+MDSUM is a special case of MSBDS, MFBDS and MLPDS. An uncacheable load from
+memory that takes a fault or assist can leave data in a microarchitectural
+structure that may later be observed using one of the same methods used by
+MSBDS, MFBDS or MLPDS.
 
 Exposure assumptions
 --------------------


