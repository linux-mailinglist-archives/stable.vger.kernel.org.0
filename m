Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CB2246551
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 13:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgHQL1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 07:27:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgHQL1L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 07:27:11 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EBF12072E;
        Mon, 17 Aug 2020 11:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597663631;
        bh=9xHlyo2BiYY/T+jraPVXVIU/n0TQ3xcC8NLLp7vd8lg=;
        h=From:To:Cc:Subject:Date:From;
        b=fiQpaf4hcczm5YVq+LzoOvnS1jJ1jZ34bULN1mFapmrHwcZ5DEr/7K7X1cTDB3GL3
         uPsUNFv3gWypQwvHiP7KChSTQIYZ3mMsOjf9NIoa1yTi6RXU8pInxCiHtrMmjEcWT8
         dML+poG1KEWklmMhQ5SoXDnEM0ETJtcAzgwvA9xw=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k7dID-003Y6k-Fq; Mon, 17 Aug 2020 12:27:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 0/2] input/hid: Fix bitmap boundary validation
Date:   Mon, 17 Aug 2020 12:26:58 +0100
Message-Id: <20200817112700.468743-1-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: dmitry.torokhov@gmail.com, jikos@kernel.org, benjamin.tissoires@redhat.com, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It recently became apparent that some of the low-level input and hid
helpers lack some form of input validation when associating an event
code with their internal capability bitmap, leading to potential
memory corruption.

These two patches address two occurrences of that issue, by masking
out the top bits of the event code (all capability bitmaps are
conveniently sized as power of twos), and spitting out a warning for
further debugging.

Marc Zyngier (2):
  Input; Sanitize event code before modifying bitmaps
  HID: core; Sanitize event code and type before mapping input

 drivers/input/input.c | 16 +++++++++++++++-
 include/linux/hid.h   | 19 +++++++++++++++----
 2 files changed, 30 insertions(+), 5 deletions(-)

-- 
2.27.0

