Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94BC8142CE7
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 15:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgATOJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 09:09:19 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:53642 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgATOJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 09:09:18 -0500
Received: by mail-pj1-f67.google.com with SMTP id n96so6835191pjc.3;
        Mon, 20 Jan 2020 06:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4CTbIeEzkXO5fB5W+Pbzr8GP/XfcEsPFM6dFVweDmW4=;
        b=VsGePNNH62qfKjyGlIoukU6+uBz2EoHFYKRvl9i0Iy+FAYTych5/siIxFb9p1kXPIN
         RTjAtSpcCAwEiNymRsJlTpffv0YCHZgsWBwex3+chnPlgAdoPt9zX0S4hfiwOoZz1AoN
         dW07A1Cbiidy2cDlD8nhzEcyfT4zRSBle+FyxHkamzp/MFfdUAHP0jmHxqrsaOZh1IXC
         083QUJJtfw1HQFtPf0Z3C1tL2wbzTLaGAfax7/H3z8jl6fbeaVeHhzooTg5rGbNi0R43
         ZnK5CFR/MP80RlX8lRD2APLt7vrM8OwPfgQMpOKYSRq3pDez1pczaveFKIQGXqvmzE2E
         Sifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4CTbIeEzkXO5fB5W+Pbzr8GP/XfcEsPFM6dFVweDmW4=;
        b=ZhQ4LiX7aQMvxQ7bME2rmF8ViXidJcsnZnlnvy9+LLfvWEJIAplDnifsrF0P1KEotp
         zNkxxPvfTOB/rZ/PDOiphlq/EHK9dm1xBk4hnjOMstLyX2EgATXTLUn28xNLtUntV4nr
         0lQJOxf4w+q4T24tzKgDXfHZmLZuvOvVqUe5Y/pd1bnbbVWKilDwaTr17P4fvvPvYKiU
         /Td+2VyCSx3ixvHz47cY4k+fuFv0dq+FForss0iiYqo3jWFbwGYkArl5fMocVHnu87Js
         FjQ6cmHrm5ArWlXA/s3DS5AzAaUjfItYgKpL98QOyrkXfwFiHTD8P8r20LxdMepZ4ry/
         7MhQ==
X-Gm-Message-State: APjAAAXVGoKtC4G8limLacHaI55mHvPHtrjVWectX8RxVPt/bqtTJm8K
        2LLkIoUUAiXRtZT0hc+NhJ9UlxGUtPeKdA==
X-Google-Smtp-Source: APXvYqz+UNZZLh0pK4TnBa4SchIF8535UKk8mnl9qxS9otojl0GkJ4cAvWWXad9ayW4pK4Vv6rMvug==
X-Received: by 2002:a17:902:8c91:: with SMTP id t17mr7482762plo.98.1579529357309;
        Mon, 20 Jan 2020 06:09:17 -0800 (PST)
Received: from glados.lan ([2601:647:4c01:6541:fa16:54ff:fed1:1bd6])
        by smtp.gmail.com with ESMTPSA id r30sm41887687pfl.162.2020.01.20.06.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 06:09:16 -0800 (PST)
From:   Thomas Hebb <tommyhebb@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Thomas Hebb <tommyhebb@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org
Subject: [PATCH v3 2/2] usb: typec: fusb302: fix "op-sink-microwatt" default that was in mW
Date:   Mon, 20 Jan 2020 06:09:06 -0800
Message-Id: <0da564559af75ec829c6c7e3aa4024f857c91bee.1579529334.git.tommyhebb@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <d8be32512efd31995ad7d65b27df9d443131b07c.1579529334.git.tommyhebb@gmail.com>
References: <d8be32512efd31995ad7d65b27df9d443131b07c.1579529334.git.tommyhebb@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8f6244055bd3 ("usb: typec: fusb302: Always provide fwnode for the
port") didn't convert this value from mW to uW when migrating to a new
specification format like it should have.

Fixes: 8f6244055bd3 ("usb: typec: fusb302: Always provide fwnode for the port")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>

---

Changes in v3: None
Changes in v2: None

 drivers/usb/typec/tcpm/fusb302.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/fusb302.c b/drivers/usb/typec/tcpm/fusb302.c
index ed8655c6af8c..b498960ff72b 100644
--- a/drivers/usb/typec/tcpm/fusb302.c
+++ b/drivers/usb/typec/tcpm/fusb302.c
@@ -1666,7 +1666,7 @@ static const struct property_entry port_props[] = {
 	PROPERTY_ENTRY_STRING("try-power-role", "sink"),
 	PROPERTY_ENTRY_U32_ARRAY("source-pdos", src_pdo),
 	PROPERTY_ENTRY_U32_ARRAY("sink-pdos", snk_pdo),
-	PROPERTY_ENTRY_U32("op-sink-microwatt", 2500),
+	PROPERTY_ENTRY_U32("op-sink-microwatt", 2500000),
 	{ }
 };
 
-- 
2.24.1

