Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B897233C21
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 01:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgG3X2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 19:28:47 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:54282 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728846AbgG3X2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 19:28:47 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F2F4CC04AD;
        Thu, 30 Jul 2020 23:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1596151726; bh=gRwlL9dkZ/MlJYWXxf+s5hLePmy5vzKV5qo7jwVvfR0=;
        h=Date:From:Subject:To:Cc:From;
        b=kDnseqNuEiwHXiPiWkjvm1baNx+1lsxx77jlPfXItBk9iFVBkG03otRzgETphIaRo
         GL8ehdRK7DxDdd8gx6Y7x5iDpJ8rCE1T2SafFNaz4ysKAXwqw/aiVCeT3NuqKHtiym
         FaUHtU0cJdZvMufRwo8kZVKXKoLKEvRlBkUUVY/6TIi6wyzKf5oRVgBR86827CNXf+
         MOnINknPqnB6FAmvxpHDAwe/HnEtxjDqo6ddADz3ClFKm/0PAreGXs24Ao+6C5/3Qf
         c4AcY0AkzZ+mJrCzXPyLKKrFmVjTGAx3SU+AslnxgfsNQRVE+nmwbHniDaIOWpmu6B
         tmQWAQbIJBoQQ==
Received: from te-lab16 (nanobot.internal.synopsys.com [10.10.186.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id 5258CA0096;
        Thu, 30 Jul 2020 23:28:44 +0000 (UTC)
Received: by te-lab16 (sSMTP sendmail emulation); Thu, 30 Jul 2020 16:28:44 -0700
Date:   Thu, 30 Jul 2020 16:28:44 -0700
Message-Id: <cover.1596151437.git.thinhn@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 0/3] usb: dwc3: gadget: Fix halt/clear_stall handling
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series fixes a couple of driver issues handling ClearFeature(halt)
request:

1) A function driver often uses set_halt() to reject a class driver protocol
command. After set_halt(), the endpoint will be stalled. It can queue new
requests while the endpoint is stalled. However, dwc3 currently drops those
requests after CLEAR_STALL. The driver should only drop started requests. Keep
the pending requests in the pending list to resume and process them after the
host issues ClearFeature(Halt) to the endpoint.

2) DWC3 should issue CLEAR_STALL command _after_ END_TRANSFER command completes.


Thinh Nguyen (3):
  usb: dwc3: gadget: Resume pending requests after CLEAR_STALL
  usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command
  usb: dwc3: gadget: Refactor ep command completion

 drivers/usb/dwc3/core.h   |  1 +
 drivers/usb/dwc3/ep0.c    | 16 +++++++++
 drivers/usb/dwc3/gadget.c | 85 +++++++++++++++++++++++++++++++----------------
 drivers/usb/dwc3/gadget.h |  1 +
 4 files changed, 75 insertions(+), 28 deletions(-)


base-commit: e3ee0e740c3887d2293e8d54a8707218d70d86ca
-- 
2.11.0

