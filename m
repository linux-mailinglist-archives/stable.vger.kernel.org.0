Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89C36E2A42
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 20:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjDNSxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 14:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDNSxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 14:53:51 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812668A62;
        Fri, 14 Apr 2023 11:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681498430; x=1713034430;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nfMyxQWFmA0UP0QEI4guCa5Nv+/6g1D3v2ozF7ucCHw=;
  b=jkDkz8E86nKBPlzaRO9qJkZGgDLTgAVeAoRAlD/zJrutQdpDlwvFFnst
   /gjXO3vtUc6SQpsehX0vPVeIHbAZ2MisCcg17tlNw0HOXTaDjRhs7bF7B
   jGobvuLc01oH9wHnswZPWW2FZPQSI71esau4ohRGpG5NamKuT3MeGhrdj
   fRY2hv8DbSxLakzhwyQssEv3dp4QEweMcqIqcsAEacgRKlIntjvz+pqFB
   DMtL4jnxOdibHU99Yip1FZbKhwitsATLTxMCwXaUIHXovr5yfpiKbh++y
   TDXO8gf+jehxFB/S0rPHRZj/JtA4z1JrJYwE+AwSQip+VR/DG27T4HD6q
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="347270233"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="347270233"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 11:53:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="683437671"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="683437671"
Received: from rkulesho-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.41.243])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 11:53:49 -0700
Subject: [PATCH 0/5] cxl/hdm: Decoder enumeration fixes
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        stable@vger.kernel.org
Date:   Fri, 14 Apr 2023 11:53:49 -0700
Message-ID: <168149842935.792294.13212627946146993066.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While testing region autodetect with physical hardware a few fixes fell
out. The most interesting being evidence that a device is sensitive to
8-byte reads of 2 consecutive 4-byte registers. The other is a long
reported issue by Jonathan on how "passthrough" decoders are detected,
and having an example with physical hardware to reinforce the
observation from QEMU.

The rest are ancillary fixes and new debug messages.

---

Dan Williams (5):
      cxl/hdm: Fail upon detecting 0-sized decoders
      cxl/hdm: Use 4-byte reads to retrieve HDM decoder base+limit
      cxl/core: Drop unused io-64-nonatomic-lo-hi.h
      cxl/port: Scan single-target ports for decoders
      cxl/hdm: Add more HDM decoder debug messages at startup


 drivers/cxl/core/hdm.c  |   52 ++++++++++++++++++++++++++++++++++++-----------
 drivers/cxl/core/mbox.c |    1 -
 drivers/cxl/core/port.c |    1 -
 drivers/cxl/port.c      |   18 ++++++++++++----
 4 files changed, 53 insertions(+), 19 deletions(-)

base-commit: 24b18197184ac39bb8566fb82c0bf788bcd0d45b
