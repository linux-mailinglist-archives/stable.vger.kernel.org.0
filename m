Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1ED7CDB3B
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 07:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfJGFNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 01:13:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33433 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbfJGFNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 01:13:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id i76so301545pgc.0;
        Sun, 06 Oct 2019 22:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w7cPe8XgAdd5CzjoP48tMEWPoIPNhWDUDvf6JLAfY+k=;
        b=VGFHYGWs8FhghIhEFHjp4j1vKgvV8rNHxDRii9T6ZOCQ8P1V9RPyqSPn+GrthlqBH1
         xoZT9ECGw+lDu5syDqsQHjpcichT3bMB8TKBey6kJQnezq/3CFSPbPY/ii/9/z/+dTlz
         ZOUJhbIJl6hJ6Z+VntseHAe5ZnmOMaUyBretPp6vyQDx6kZ2iAPR4n1KW8Hvo7owAwjn
         zrLkPpkIIz0dBzygJWizzC61hBr1I14RECWxBZwt0l0CTGb7z533J2Z9DrB7kjvREh55
         g8ClJN7f8veberDN1TEtosSFSyJk2UTrXlJdJq7pRz+f27LV/Q0U2gs188PiCJP/67FA
         i4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w7cPe8XgAdd5CzjoP48tMEWPoIPNhWDUDvf6JLAfY+k=;
        b=eoVWbmfZQBFkY9GxK++sZQnkNSf6vRK6skOfsnnwhks/i3EHAqGclhaAuBacdtKbhW
         4Zx7FIbAfhfEFAaKeXpM8byTG+K3GTfmjo1grrJnMxsZl9KlXrT0DA4hAEEh/hZ/mUvb
         CD+Yq/bdC9QlXcAXcNpQfAzKopNx0qzRJAEBbzC6xKE5bbk/CKsg/61gUSdiUQ7dDsLf
         35sPQfcF9oZirhRlmFP5jPqb7L0ThGEO4ZUp5fXnSNPHnINqNUG/xJxfyVnuZdHvTVFj
         VS87CQKmEoqAmOWCh101qUBocz05P7NISkDAQu8upbeBuyShxqDPGn6+xeBVmYN0vOVq
         4M6g==
X-Gm-Message-State: APjAAAVLcMYLkh5Lupl8YPSfiU/u6h5XLnlKufnGpzRgEDeLWgXHFgrj
        UWtkd52BqhQrvTFP/U2/2LgdbiWgcxo=
X-Google-Smtp-Source: APXvYqyfD9UwbWSvMtHp98TcyDenNkyWyvaxFJRQxIOQMDLb3BtDv7l7UvpN0qY3rYEK6ceAxU3xzQ==
X-Received: by 2002:aa7:9e01:: with SMTP id y1mr31113646pfq.175.1570425177637;
        Sun, 06 Oct 2019 22:12:57 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id v133sm2209680pgb.74.2019.10.06.22.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2019 22:12:56 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-input@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Sam Bazely <sambazley@fastmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 0/3] Logitech G920 fixes
Date:   Sun,  6 Oct 2019 22:12:37 -0700
Message-Id: <20191007051240.4410-1-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Everyone:

This series contains patches to fix a couple of regressions in G920
wheel support by hid-logitech-hidpp driver. Without the patches the
wheel remains stuck in autocentering mode ("resisting" any attempt to
trun) as well as missing support for any FF action.

Thanks,
Andrey Smirnov

Andrey Smirnov (3):
  HID: logitech-hidpp: use devres to manage FF private data
  HID: logitech-hidpp: split g920_get_config()
  HID: logitech-hidpp: add G920 device validation quirk

 drivers/hid/hid-logitech-hidpp.c | 193 +++++++++++++++++++------------
 1 file changed, 120 insertions(+), 73 deletions(-)

-- 
2.21.0

