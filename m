Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A67A142CEC
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 15:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgATOJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 09:09:16 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39046 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgATOJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 09:09:16 -0500
Received: by mail-pg1-f194.google.com with SMTP id 4so3127585pgd.6;
        Mon, 20 Jan 2020 06:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=azI73W9R2N/YRZD4EUVzDaRxmA/JCQDA+hkfk6C3vOo=;
        b=h2BfhAHom2dOYlT+2NYPgJCC2YZPL6t6rNSSStqF4vXQ3Vk3sS0sSNtAUBURdGzh8q
         fGeu2sKLLzc4sjfLTSw5XMX7FiXJD7X+pOBwcLQUSxjMrvJzxO9jwK4btB81VimxRF3M
         d0noGN8qMdtqt240cBcbBwbS+q3LtIYxcIM2ReR3LlXh9zQB6SrT8BdCHfoYyvb3SzwM
         87svpE2px/LY7n/10DwzHIQVa7DlDOIAt+I/0qntmoqovOUMxfMrhrfmPn7UcySdOCs5
         wP3fNyNdPMcxX9I2FQ1CVBxbnMdIlnUhKcJbSGH98XeOAV5DdPzlQn7BPxfVFeaB4Daf
         Rzyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=azI73W9R2N/YRZD4EUVzDaRxmA/JCQDA+hkfk6C3vOo=;
        b=S3doONC1Iz3B+NslYiVe8tvLgLCsvDKQDUx0jWNUaJ8b02f41In0ugUdUgDanWqKcf
         YwJ0A07hCxvggPvyU8jo4C+rpubpy4qcUN8V/6oq1PYvySlRCQVX9jt2nG/2miRdw3QO
         6apPsjzqRDU8DAOaZYxniV1fMU33eyGJhYQYbIwIdmzMeaOFzMmuIYNu1vzpNm3L2Ffc
         2BFCu48JffCsO1aWFxr+uqhnxDpMzWRKoUF50sptk22AdOlpdQisnHzt7MIzH7jrVxBZ
         SXJs1ue5XeZddgX1YWWs6Ew+ZxBdsIij7UT1lAhV+De0shMcHaBB5PyFDe8BfZh5Sfz2
         sepQ==
X-Gm-Message-State: APjAAAWsUqESI4CQJN0l1ZRBDJph+f5LstEUdap96JO6a/r+yUe6E89T
        j3ZuuYLbFJITlN8vYlF7gcftBv8CeATihA==
X-Google-Smtp-Source: APXvYqxbHJlCrHRDMDj+iEnPpg8rxHoLARAyopHvK9vnteZt/PScJ+4UDWTab4IHj3Q4Rb2lFMULSQ==
X-Received: by 2002:a65:68d4:: with SMTP id k20mr61254026pgt.142.1579529354965;
        Mon, 20 Jan 2020 06:09:14 -0800 (PST)
Received: from glados.lan ([2601:647:4c01:6541:fa16:54ff:fed1:1bd6])
        by smtp.gmail.com with ESMTPSA id r30sm41887687pfl.162.2020.01.20.06.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 06:09:14 -0800 (PST)
From:   Thomas Hebb <tommyhebb@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Thomas Hebb <tommyhebb@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH v3 1/2] usb: typec: wcove: fix "op-sink-microwatt" default that was in mW
Date:   Mon, 20 Jan 2020 06:09:05 -0800
Message-Id: <d8be32512efd31995ad7d65b27df9d443131b07c.1579529334.git.tommyhebb@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4c912bff46cc ("usb: typec: wcove: Provide fwnode for the port")
didn't convert this value from mW to uW when migrating to a new
specification format like it should have.

Fixes: 4c912bff46cc ("usb: typec: wcove: Provide fwnode for the port")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>

---

Changes in v3:
- Use the right stable email address

Changes in v2:
- Split fix into two patches
- Added stable cc

 drivers/usb/typec/tcpm/wcove.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/wcove.c b/drivers/usb/typec/tcpm/wcove.c
index edc271da14f4..9b745f432c91 100644
--- a/drivers/usb/typec/tcpm/wcove.c
+++ b/drivers/usb/typec/tcpm/wcove.c
@@ -597,7 +597,7 @@ static const struct property_entry wcove_props[] = {
 	PROPERTY_ENTRY_STRING("try-power-role", "sink"),
 	PROPERTY_ENTRY_U32_ARRAY("source-pdos", src_pdo),
 	PROPERTY_ENTRY_U32_ARRAY("sink-pdos", snk_pdo),
-	PROPERTY_ENTRY_U32("op-sink-microwatt", 15000),
+	PROPERTY_ENTRY_U32("op-sink-microwatt", 15000000),
 	{ }
 };
 
-- 
2.24.1

