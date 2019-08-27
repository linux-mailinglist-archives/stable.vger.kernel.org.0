Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652D59E17E
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730285AbfH0IMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730809AbfH0H7O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:59:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3197E2186A;
        Tue, 27 Aug 2019 07:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892753;
        bh=FSfcG/9Y4fiGy/iFk9Uk6lrJU6yMcP4v2223qcX1u9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLp7ho1y+SKxtRuSBYMNTzJC0bED33xFGsvzl47gjm1ThTRQsYYlzwQ/bt14pAU+c
         JKp8wD2leJWmx8Go0KK505khHuLl8fg9o3/xdW1rsNifY8OOD905+ULCw+Z9jJEfNO
         YiMAtuFwnjeyZs1dGkhMhKog7KxsSmimFljXtIao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 59/98] HID: wacom: correct misreported EKR ring values
Date:   Tue, 27 Aug 2019 09:50:38 +0200
Message-Id: <20190827072721.400101505@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Armstrong Skomra <skomra@gmail.com>

commit fcf887e7caaa813eea821d11bf2b7619a37df37a upstream.

The EKR ring claims a range of 0 to 71 but actually reports
values 1 to 72. The ring is used in relative mode so this
change should not affect users.

Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Fixes: 72b236d60218f ("HID: wacom: Add support for Express Key Remote.")
Cc: <stable@vger.kernel.org> # v4.3+
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_wac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1061,7 +1061,7 @@ static int wacom_remote_irq(struct wacom
 	input_report_key(input, BTN_BASE2, (data[11] & 0x02));
 
 	if (data[12] & 0x80)
-		input_report_abs(input, ABS_WHEEL, (data[12] & 0x7f));
+		input_report_abs(input, ABS_WHEEL, (data[12] & 0x7f) - 1);
 	else
 		input_report_abs(input, ABS_WHEEL, 0);
 


