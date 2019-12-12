Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDD411C56C
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 06:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfLLF3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 00:29:04 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40436 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfLLF3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 00:29:04 -0500
Received: by mail-pg1-f196.google.com with SMTP id k25so526992pgt.7;
        Wed, 11 Dec 2019 21:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cg5lGbhizOwb+tnRA8SvOrnpW+A7N5IliX8lmwh9HY8=;
        b=lSqx+gVRq1/ReD8YLvPh1EJX6TMuCOCw4qHrpmhLhK0gw9tBhs+ElZVzj/QCu76tsM
         RyQW5jdL/QR8KEfo5OydmoagfQ+4oyJIiuCmJdr/q32ecpHwBZb93WREXjjbCBz9xDov
         EQDAIxK9+uj1XKBf4tgrYdpH4qjoNxDap0kkFiL5I66ZPm5Xu4LdqkkkwrEtwFs2bq0M
         ICF8oZmZSBqo7aTjTy5C9usMsKKRMW9cFD8OaNyKgP2hK0OChOJiF5FwKhsgb+w7JA6e
         976makL8lvndjiMQn17SgNLbcHPstnc7U8utbo45sj4Ym98AeMQHJsRqZ2Uw6HJpU/hk
         b8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cg5lGbhizOwb+tnRA8SvOrnpW+A7N5IliX8lmwh9HY8=;
        b=ETHGPxCUzE4GPufwQyO3+1mttCajJ9IVZyGxh3ZdO0L94vAEHgp9/d4aD3OQ5MuPxQ
         7PW7lo5ZADgy5GWDJforpp+nTAu9T5U76BcVtSWIdhg5YwdwjDYEnMxhbpwrmJPySSCr
         HLhQ/Vvx7oasulf4KP1+B8H4EB65dAnJGMm44h3jIGTErgSEFPjcNBLzxFLDBvf5zjo8
         ILFRolU2wef3spE7TA8eUtI6N5gzSXqXGRTAGij8dGqXi13xPuZkfkBjc1Tjj/29C7kk
         OfehJUF7JCBVz5IEXey4mx5cgE2H22z+xTbWa8I3ZU1U2u5IEBAX1cG8M8C4oGbk1SgF
         X7zA==
X-Gm-Message-State: APjAAAUV0+NionjWEvPrlzaGX1QCwgZXhyxra1Rf+vQjDLu2+JKj1VCO
        9X5+roFyH5upMlrc54eSw3z8fV1e
X-Google-Smtp-Source: APXvYqx7AiOlM7CXVuO+TdH4bu5W0Rsf9qS8x6I+B4ZGTmFyxqAj998tZBAZk4Msw9in4QpBaPpywQ==
X-Received: by 2002:a63:9d07:: with SMTP id i7mr8867378pgd.344.1576128543447;
        Wed, 11 Dec 2019 21:29:03 -0800 (PST)
Received: from localhost.localdomain ([163.152.162.99])
        by smtp.gmail.com with ESMTPSA id h7sm5532289pfq.36.2019.12.11.21.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 21:29:02 -0800 (PST)
From:   Suwan Kim <suwan.kim027@gmail.com>
To:     shuah@kernel.org, valentina.manea.m@gmail.com,
        gregkh@linuxfoundation.org, marmarek@invisiblethingslab.com
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Suwan Kim <suwan.kim027@gmail.com>
Subject: [PATCH 0/2] usbip: Fix infinite loop in vhci rx
Date:   Thu, 12 Dec 2019 14:28:39 +0900
Message-Id: <20191212052841.6734-1-suwan.kim027@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

usbip: Fix infinite loop in vhci rx

https://lore.kernel.org/linux-usb/20191206032406.GE1208@mail-itl/T/#u
In this mail thread, it shows system hang when there is receive
error in vhci. There are two different causes in this bug.

[1] Wrong receive logic in vhci when using scatter-gather
[2] Wrong error path of vhci_recv_ret_submit()

[1] considers normal reception to be an error condition and closes
connection. And when [1] error situation occurs, wrong error path[2]
causes the system freeze. So each patch fixes this bugs.

Suwan Kim (2):
  usbip: Fix receive error in vhci-hcd when using scatter-gather
  usbip: Fix error path of vhci_recv_ret_submit()

 drivers/usb/usbip/usbip_common.c |  3 +++
 drivers/usb/usbip/vhci_rx.c      | 13 +++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

-- 
2.20.1

