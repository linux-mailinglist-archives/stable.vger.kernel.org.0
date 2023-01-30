Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E9F680C6A
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 12:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236664AbjA3Lti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 06:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236693AbjA3Ltd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 06:49:33 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4BA2CC5F;
        Mon, 30 Jan 2023 03:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675079340; x=1706615340;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rKk3BcTrOaYcavGP7FjeV9tA755cnL8HiSR0t7sd6Fg=;
  b=danzpZ975VUc2SLLAeo8HtPhjR+knyC1nescji9+GrDJBpJ+2K4zvgnt
   umX3PiPVux8+Lie8ytG2PFEP7WOjxJBEPkOfUmcIp+0Kk5BECVeISG0Wb
   sHbo0Rq8l+6iyj2K/IBgxCI27eXfY+K3Fe/kVapNszl/pmXzaHeKZE0hO
   KqpBEKoSFteHXCZf5zJp8n9baqRBUFU6jWw8KXQaHyqdwz23/hqWKYYev
   G+N1Bs1SGvIRJ3EE2axU15kv6UDvrAw895Mn1iNBDOZJkML1aOmKnPVhW
   72kw8O6ldZuFoyOHN+xB8i43aYyCLAizlEkAtE3rLs4kFfuIi3fnVS/Sl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="307882334"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="307882334"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 03:48:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="732672095"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="732672095"
Received: from nbelenko-mobl.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.251.210.56])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 03:48:49 -0800
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-serial@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Gilles BULOZ <gilles.buloz@kontron.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 0/2] serial: 8250_dma: DMA Rx race fixes
Date:   Mon, 30 Jan 2023 13:48:39 +0200
Message-Id: <20230130114841.25749-1-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix two races in DMA Rx completion and rearm handling.

I know in advance that the first patch will not be backport friendly
because of commit 56dc5074cbec ("serial: 8250_dma: Rearm DMA Rx if more
data is pending") that is not even in 6.1 but I can create the custom
backport on request.

Cc: stable@vger.kernel.org

Ilpo Järvinen (2):
  serial: 8250_dma: Fix DMA Rx completion race
  serial: 8250_dma: Fix DMA Rx rearm race

 drivers/tty/serial/8250/8250_dma.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

-- 
2.30.2

