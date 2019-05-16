Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3DB20C0F
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbfEPQB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:01:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42908 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727044AbfEPP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:46 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImJ-0006zU-Hy; Thu, 16 May 2019 16:58:43 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImF-0001Sx-6L; Thu, 16 May 2019 16:58:39 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jon Masters" <jcm@redhat.com>,
        "Pawan Gupta" <pawan.kumar.gupta@linux.intel.com>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "speck for Pawan Gupta" <speck@linutronix.de>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.987159285@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 82/86] x86/mds: Add MDSUM variant to the MDS
 documentation
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/hw-vuln/mds.rst | 5 +++--
 Documentation/x86/mds.rst     | 5 +++++
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

