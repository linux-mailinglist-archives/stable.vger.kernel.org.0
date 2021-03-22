Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714893442B5
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhCVMoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:44:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232511AbhCVMmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:42:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD400619B2;
        Mon, 22 Mar 2021 12:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416830;
        bh=+N/vEXPFA2h7Hs+Xp+Ysnyf4OFcbKK4iAvPi5aDZgn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=REtLCEt3c9i3BDhWHbr9DX2aersabCgdFf7wr0loKq95OlJLrBf6MnJhNLyey64D5
         rguhY6PzWz/kyXkbDIRSMyWCVb3s8vqwWJpoDEGHUAT/dN8Xbc7pBt16ANfrCoVJEe
         CSxeLTW6vxSQTufP0PKgVWY/nFxXUkktXsZ4NGAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 137/157] PCI: rpadlpar: Fix potential drc_name corruption in store functions
Date:   Mon, 22 Mar 2021 13:28:14 +0100
Message-Id: <20210322121938.098376300@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.ibm.com>

commit cc7a0bb058b85ea03db87169c60c7cfdd5d34678 upstream.

Both add_slot_store() and remove_slot_store() try to fix up the
drc_name copied from the store buffer by placing a NUL terminator at
nbyte + 1 or in place of a '\n' if present. However, the static buffer
that we copy the drc_name data into is not zeroed and can contain
anything past the n-th byte.

This is problematic if a '\n' byte appears in that buffer after nbytes
and the string copied into the store buffer was not NUL terminated to
start with as the strchr() search for a '\n' byte will mark this
incorrectly as the end of the drc_name string resulting in a drc_name
string that contains garbage data after the n-th byte.

Additionally it will cause us to overwrite that '\n' byte on the stack
with NUL, potentially corrupting data on the stack.

The following debugging shows an example of the drmgr utility writing
"PHB 4543" to the add_slot sysfs attribute, but add_slot_store()
logging a corrupted string value.

  drmgr: drmgr: -c phb -a -s PHB 4543 -d 1
  add_slot_store: drc_name = PHB 4543°|<82>!, rc = -19

Fix this by using strscpy() instead of memcpy() to ensure the string
is NUL terminated when copied into the static drc_name buffer.
Further, since the string is now NUL terminated the code only needs to
change '\n' to '\0' when present.

Cc: stable@vger.kernel.org
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
[mpe: Reformat change log and add mention of possible stack corruption]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210315214821.452959-1-tyreld@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/hotplug/rpadlpar_sysfs.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/pci/hotplug/rpadlpar_sysfs.c
+++ b/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -34,12 +34,11 @@ static ssize_t add_slot_store(struct kob
 	if (nbytes >= MAX_DRC_NAME_LEN)
 		return 0;
 
-	memcpy(drc_name, buf, nbytes);
+	strscpy(drc_name, buf, nbytes + 1);
 
 	end = strchr(drc_name, '\n');
-	if (!end)
-		end = &drc_name[nbytes];
-	*end = '\0';
+	if (end)
+		*end = '\0';
 
 	rc = dlpar_add_slot(drc_name);
 	if (rc)
@@ -65,12 +64,11 @@ static ssize_t remove_slot_store(struct
 	if (nbytes >= MAX_DRC_NAME_LEN)
 		return 0;
 
-	memcpy(drc_name, buf, nbytes);
+	strscpy(drc_name, buf, nbytes + 1);
 
 	end = strchr(drc_name, '\n');
-	if (!end)
-		end = &drc_name[nbytes];
-	*end = '\0';
+	if (end)
+		*end = '\0';
 
 	rc = dlpar_remove_slot(drc_name);
 	if (rc)


