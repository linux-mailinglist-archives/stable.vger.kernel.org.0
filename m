Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A0D38EF49
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbhEXP4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235152AbhEXPzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16B7761456;
        Mon, 24 May 2021 15:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870946;
        bh=Oo3ztTKrT4fQjPNpGhU0AtG7+1T9vobNl4gDim5UShs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iq1X9fyOCX1SlzHcmkvOwCxn+r3jn1bG7HnGKoXzK3GDRQevpe64jV/GiFcd5JhwR
         KvqRH8BpKrDsdFcZh3R7JliviPDP5mI6cMU1tW4xLC4ozIHpHo97drx81l4N9N5U/r
         u02FuwxPOfvK3LIjq0Crj+Ea3bb9dNIV2Y/MfQF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 5.10 091/104] ics932s401: fix broken handling of errors when word reading fails
Date:   Mon, 24 May 2021 17:26:26 +0200
Message-Id: <20210524152335.866763702@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

commit a73b6a3b4109ce2ed01dbc51a6c1551a6431b53c upstream.

In commit b05ae01fdb89, someone tried to make the driver handle i2c read
errors by simply zeroing out the register contents, but for some reason
left unaltered the code that sets the cached register value the function
call return value.

The original patch was authored by a member of the Underhanded
Mangle-happy Nerds, I'm not terribly surprised.  I don't have the
hardware anymore so I can't test this, but it seems like a pretty
obvious API usage fix to me...

Fixes: b05ae01fdb89 ("misc/ics932s401: Add a missing check to i2c_smbus_read_word_data")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20210428222534.GJ3122264@magnolia
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/ics932s401.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/ics932s401.c
+++ b/drivers/misc/ics932s401.c
@@ -134,7 +134,7 @@ static struct ics932s401_data *ics932s40
 	for (i = 0; i < NUM_MIRRORED_REGS; i++) {
 		temp = i2c_smbus_read_word_data(client, regs_to_copy[i]);
 		if (temp < 0)
-			data->regs[regs_to_copy[i]] = 0;
+			temp = 0;
 		data->regs[regs_to_copy[i]] = temp >> 8;
 	}
 


