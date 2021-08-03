Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532FD3DF3DF
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 19:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238177AbhHCRZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 13:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238071AbhHCRZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 13:25:50 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89170C061757
        for <stable@vger.kernel.org>; Tue,  3 Aug 2021 10:25:38 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id c9so5863931wri.8
        for <stable@vger.kernel.org>; Tue, 03 Aug 2021 10:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fikxz6m7nLtIUxzcxfvtkYHHMgYkclWBOg9VXYihnPw=;
        b=hxgIQ280QUzCdlXWaO9fcAbU8qE15shqtnNoyLO/mA2kwayZNeLy7nkwJvP8lzdiM+
         pEHLAv7vDR5UAvr5kgKTAIZXbt0nECepbb4lDo/oGz93HnNkm02FQ2bA3lh7yC9iY+kd
         sdkFjEeAV/O3jRIsM8ywkB8FOkw01sfrv0na4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fikxz6m7nLtIUxzcxfvtkYHHMgYkclWBOg9VXYihnPw=;
        b=GY1RXyA2Rs6Vf/PBP/n24J9afwgtnrR88wtuqhFGTCaw5Wlqk5dycNbtGqcEP8X5rv
         wzjhs1KxBoornGblsI7vGNaNTFx2qHES7aD+YflXco5Ovw4EeteGIQdAs0tTrCHFfb/7
         c55kk7GlnoC6pykIqZO3FnK6+QCahXCS/waqcJwAj8UyzJ87YajeTDnlf2loGK6tCxeG
         v8eqER7GVWoAoSS6Du9GxDHvdJKQTqKS0jzCJsb49VhN9SKX/v/cCBowaKuv0SJt1Yup
         WgU7uIahSFk7qMlB/zckKzHVuVNTlIfvqhQNpddBwOeCcWeEEXi4EHsTzme+J4Ds1l5t
         q4cw==
X-Gm-Message-State: AOAM533D7mIG22Bmcj0V6TuL14FF4tptD93gX1yHGBOl/M6QEoQrTI5o
        jKUDdKSVd12+sXM9uyazRU5gxg==
X-Google-Smtp-Source: ABdhPJwhBubg85ICYXjME3WV8v9BP2tHzfYUtn/hU2vBpbqtcwoZyYM38A6CbIR66vTiP8XSrEziyA==
X-Received: by 2002:adf:f2cd:: with SMTP id d13mr24243070wrp.315.1628011537181;
        Tue, 03 Aug 2021 10:25:37 -0700 (PDT)
Received: from taos.k.g (lan.nucleusys.com. [92.247.61.126])
        by smtp.gmail.com with ESMTPSA id e5sm18489190wrr.36.2021.08.03.10.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 10:25:36 -0700 (PDT)
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     netdev@vger.kernel.org
Cc:     paskripkin@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        Petko Manolov <petkan@nucleusys.com>
Subject: [PATCH net v3 0/2] net: usb: pegasus: better error checking and DRIVER_VERSION removal
Date:   Tue,  3 Aug 2021 20:25:22 +0300
Message-Id: <20210803172524.6088-1-petko.manolov@konsulko.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>

v3:

Pavel Skripkin again: make sure -ETIMEDOUT is returned by __mii_op() on timeout
condition;

v2:

Special thanks to Pavel Skripkin for the review and who caught a few bugs.
setup_pegasus_II() would not print an erroneous message on the success path.

v1:

Add error checking for get_registers() and derivatives.  If the usb transfer
fail then just don't use the buffer where the legal data should have been
returned.

Remove DRIVER_VERSION per Greg KH request.

Petko Manolov (2):
  Check the return value of get_geristers() and friends;
  Remove the changelog and DRIVER_VERSION.

 drivers/net/usb/pegasus.c | 138 +++++++++++++++++++++-----------------
 1 file changed, 77 insertions(+), 61 deletions(-)

-- 
2.30.2

