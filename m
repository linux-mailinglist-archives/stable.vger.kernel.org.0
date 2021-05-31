Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3341A3961AC
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhEaOpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233330AbhEaOlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:41:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E6D761374;
        Mon, 31 May 2021 13:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469193;
        bh=6F4LA1KYJub7FaLxg+TkDK0L6lJ+/RJtGLAZGeI3SSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lijcUevikvNeKwSILYoF6aPeHjYhVk8zV0aC6O43uh+xMANhYCJkT4d/JFHp1RbHx
         qdeVYYzTYZYiULMLwXgfe+/1ZBwav6jjWUJALFM1e52I2BHln2hVzJvUtt6HaaDefr
         zWlnK/6ds1X92Emg4c3As4FGQjn2kglGa4JGgZnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.12 105/296] usb: typec: mux: Fix matching with typec_altmode_desc
Date:   Mon, 31 May 2021 15:12:40 +0200
Message-Id: <20210531130707.466835594@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit acf5631c239dfc53489f739c4ad47f490c5181ff upstream.

In typec_mux_match() "nval" is assigned the number of elements in the
"svid" fwnode property, then the variable is used to store the success
of the read and finally attempts to loop between 0 and "success" - i.e.
not at all - and the code returns indicating that no match was found.

Fix this by using a separate variable to track the success of the read,
to allow the loop to get a change to find a match.

Fixes: 96a6d031ca99 ("usb: typec: mux: Find the muxes by also matching against the device node")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210516034730.621461-1-bjorn.andersson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/mux.c
+++ b/drivers/usb/typec/mux.c
@@ -191,6 +191,7 @@ static void *typec_mux_match(struct fwno
 	bool match;
 	int nval;
 	u16 *val;
+	int ret;
 	int i;
 
 	/*
@@ -218,10 +219,10 @@ static void *typec_mux_match(struct fwno
 	if (!val)
 		return ERR_PTR(-ENOMEM);
 
-	nval = fwnode_property_read_u16_array(fwnode, "svid", val, nval);
-	if (nval < 0) {
+	ret = fwnode_property_read_u16_array(fwnode, "svid", val, nval);
+	if (ret < 0) {
 		kfree(val);
-		return ERR_PTR(nval);
+		return ERR_PTR(ret);
 	}
 
 	for (i = 0; i < nval; i++) {


