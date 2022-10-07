Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4EE5F76A2
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 12:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiJGKJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 06:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiJGKJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 06:09:39 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F85B69;
        Fri,  7 Oct 2022 03:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665137375; x=1696673375;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ntbOPNyLNjMZGzyFQOgCOtXM5VLPqnEfepUtnJip/PA=;
  b=lXBAV5c5CCybroI4igBTY8Yu+cdEPzsdd82d00eHbzehexvU/Z0bLV+7
   Kfo21KEp+o1pURESYub+6Le26LK6xL6CXp1N5iaHW9gfv+uiADzK9ZGX6
   8xdDyBv3DrX44QDMGFdnT/m73l39FgXmQ6VJzK2L6qnlvTU9aZsFPmspg
   rDSwiBXcDqomLdiXYIY/+2n+yTeL1VE7R1ew2//8n+hD8AnxpaUTxTR6C
   J9WU7Z1uzzzb5+yluZwd0pvBblfLiaV4mP74/t5/aXaTsJ5NyNE5O1Y9p
   8YcDuGtaWWFz463M5XJEKkmCpiCsGYaqVH8pZ9Y6ZAAq1uIq25oQJWRZr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="330140294"
X-IronPort-AV: E=Sophos;i="5.95,166,1661842800"; 
   d="scan'208";a="330140294"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2022 03:09:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="767530612"
X-IronPort-AV: E=Sophos;i="5.95,166,1661842800"; 
   d="scan'208";a="767530612"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2022 03:09:31 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bastian Rieck <bastian@rieck.me>, grzegorz.alibozek@gmail.com,
        andrew.co@free.fr, meven29@gmail.com, pchernik@gmail.com,
        jorge.cep.mart@gmail.com, danielmorgan@disroot.org,
        bernie@codewiz.org, saipavanchitta1998@gmail.com,
        rubin@starset.net, maniette@gmail.com, nate@kde.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v1 0/2] usb: typec: UCSI resume fix
Date:   Fri,  7 Oct 2022 13:09:49 +0300
Message-Id: <20221007100951.43798-1-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

These two patches fix an issue where the ucsi drivers fail to detect
changes on the connection status (connections/disconnections) that
happen while the system is suspended.


Heikki Krogerus (2):
  usb: typec: ucsi: Check the connection on resume
  usb: typec: ucsi: acpi: Implement resume callback

 drivers/usb/typec/ucsi/ucsi.c      | 42 +++++++++++++++++++++---------
 drivers/usb/typec/ucsi/ucsi_acpi.c | 10 +++++++
 2 files changed, 39 insertions(+), 13 deletions(-)

-- 
2.35.1

