Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1462211DC1C
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 03:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731949AbfLMCbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 21:31:24 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43065 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731330AbfLMCbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 21:31:23 -0500
Received: by mail-pg1-f194.google.com with SMTP id k197so742542pga.10;
        Thu, 12 Dec 2019 18:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Hol3+lf9Q1WEH3PYL08Klkjcqmz+i/TdTTY2wPCXu0=;
        b=sMAM+RGOCKNK0FCCyt24yhdbMV3xZ7fjM8uL8/Ep/w7yIKmhLlNXzCsLfYPP982Iu4
         qyhEmLgFyqQqlFTbO8xwRfQZYdO9g2L3Wl6hX+VyR5AeDodKFUJjz2zULK+uQeRIyrjp
         wQ48LeuQzYLP/CVldDI/Bc62lqinxxHp0abwpUnA3zBDMXWom6ZWq9QnWLoORsZJBHTQ
         27cUee7a6fsXqkgejAJUiWKVS97U703fQgvUBwf3vrSrpV3nuyn63Cfhqgm6nETgNWHl
         C78Fl0vpDZwzR8P0sl34tJ0M4DbOoN70aKjOmZ9JPypQt72ibMeT3oNcEdWs3O1QjIPw
         HWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Hol3+lf9Q1WEH3PYL08Klkjcqmz+i/TdTTY2wPCXu0=;
        b=BbBjqQJyV/P/eK6/hbDPSL/kpXr8z7z8Er/f++lmAZHFCwY5Lw1Rhg7g03vwnzNJ9M
         E/9qlDj3a/HjVc/4jkv5LVz5Q5pLCWAVyTcLabOzO5EB3JD+AGhovgxJnhvAeADXFuaK
         fdbUp0v+gQTcRtYHNGf88LQf/y1H4yjohVoENTXt/FYCrmxvb/gR5kdg3M0THSfUjrwb
         lDuLAorP3wt9b7scyAW/u/PxL7SUbIMeDVh12Sdu86lbwEjCOdhC0knQ2XyVmw6mjmXb
         mmb5zWTT4NWxZymLRS4qJqyH0dh74u0UhAnY0K2ZtkeTt7ENlY/NiJO1BvmjtjphhRkL
         97xw==
X-Gm-Message-State: APjAAAUaGlRB6lQbxjaTvoPmGv0S2koxN0Mm6bEFlpVA+ypxmM0OVrFj
        0xMLGIhGhttmyX5Vvts3ghQ=
X-Google-Smtp-Source: APXvYqzUlblKsW/MVnkW9lTQFQsV+A8BNjPKrnN/uCrdxW0cqZn2WtbPl2U2rbzX9cZnHAg05T84vw==
X-Received: by 2002:a63:150d:: with SMTP id v13mr4781753pgl.342.1576204282371;
        Thu, 12 Dec 2019 18:31:22 -0800 (PST)
Received: from localhost.localdomain ([163.152.162.99])
        by smtp.gmail.com with ESMTPSA id h68sm9443654pfe.162.2019.12.12.18.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 18:31:21 -0800 (PST)
From:   Suwan Kim <suwan.kim027@gmail.com>
To:     shuah@kernel.org, valentina.manea.m@gmail.com,
        gregkh@linuxfoundation.org, marmarek@invisiblethingslab.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu,
        Suwan Kim <suwan.kim027@gmail.com>
Subject: [PATCH v2 0/2] usbip: Fix infinite loop in vhci rx
Date:   Fri, 13 Dec 2019 11:30:53 +0900
Message-Id: <20191213023055.19933-1-suwan.kim027@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

https://lore.kernel.org/linux-usb/20191206032406.GE1208@mail-itl/T/#u
In this mail thread, it shows system hang when there is receive
error in vhci. There are two different causes in this bug.

[1] Wrong receive logic in vhci when using scatter-gather
[2] Wrong error path of vhci_recv_ret_submit()

[1] considers normal reception to be an error condition and closes
connection. And when [1] error situation occurs, wrong error path[2]
causes the system freeze. So each patch fixes this bugs.

---
Change log

Patch [1] - Add Tested-by tag
Patch [2] - Add Tested-by tag
          - Fix typo
          - Fix error code in urb->status (-EPIPE->-EPROTO)

Suwan Kim (2):
  usbip: Fix receive error in vhci-hcd when using scatter-gather
  usbip: Fix error path of vhci_recv_ret_submit()

 drivers/usb/usbip/usbip_common.c |  3 +++
 drivers/usb/usbip/vhci_rx.c      | 13 +++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

-- 
2.20.1

