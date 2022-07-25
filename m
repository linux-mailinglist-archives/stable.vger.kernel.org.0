Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2918F5803BE
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 20:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbiGYSFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 14:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiGYSFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 14:05:02 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C5413F10
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 11:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658772301; x=1690308301;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+yxyul0anxmwhuZL0Khjpg0l+CM0bs9vyR9TMeVujOs=;
  b=PhjoGbfU9lM+geoRgBJP5u2QNb0IeWjnl+QKqzPBM8PJJj7QGOnkUZ1I
   /cE32v4UDkou496KrhotqL+fLoMYcdWBazFxAt7WyZzjTf6MzYvAHUfgk
   RTmMj+aAvHt9ICBWcd9BZnc5AQ5MDSoVPuZXsZmFZtAIkNHQuN8Cp8sT6
   5c1MJH6xitd+esiyYi/mC45ArNvstuTGNARFXafWfJSnUx2ZMnNNwFzzT
   jnvj6ek06JMar3UxjUaCs5vl1pNeRE6H3WfD5kDCy6S75Q/0WH7I6mW8a
   +nK6aZW+24+snIfFlqq1MGOid6bNFFYcUgQhHhF65UeovHFFE3Pei/h/4
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="274627565"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="274627565"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 11:05:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="632449948"
Received: from jxzhao-mobl.amr.corp.intel.com (HELO pbossart-mobl3.intel.com) ([10.212.0.178])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 11:04:59 -0700
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, broonie@kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Subject: [PATCH v2 0/3][5.18.y backport] ASoC: SOF: Intel: fix resume from hibernate
Date:   Mon, 25 Jul 2022 13:04:46 -0500
Message-Id: <20220725180449.12742-1-pierre-louis.bossart@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport for 5.18 stable, the first two patches were not modified,
only the third patch had a missing dependency with 2a68ff846164
("ASoC: SOF: Intel: hda: Revisit IMR boot sequence")

v2: updated commit IDs - no code change

Pierre-Louis Bossart (3):
  ASoC: SOF: pm: add explicit behavior for ACPI S1 and S2
  ASoC: SOF: pm: add definitions for S4 and S5 states
  ASoC: SOF: Intel: disable IMR boot when resuming from ACPI S4 and S5
    states

 sound/soc/sof/intel/hda-loader.c |  3 ++-
 sound/soc/sof/pm.c               | 21 ++++++++++++++++++++-
 sound/soc/sof/sof-priv.h         |  2 ++
 3 files changed, 24 insertions(+), 2 deletions(-)

-- 
2.34.1

