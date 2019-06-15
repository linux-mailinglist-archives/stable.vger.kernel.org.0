Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81AAE46DDA
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 04:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbfFOCi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 22:38:26 -0400
Received: from smtpbgau1.qq.com ([54.206.16.166]:58612 "EHLO smtpbgau1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfFOCi0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 22:38:26 -0400
X-QQ-GoodBg: 0
X-QQ-SSF: 00100000000000F0
X-QQ-FEAT: OthLD3hRvFH68HUK1fSaSSzLkheWD/BKXU9BkEf5QT3Kbms62pcXhu1Xa1BGD
        4vY41PSVM32RRdOpAi+XVOb3ykuWX+2sQjuVCvU98edyIHeFPlORkOQz10HIAB3bXXub4iB
        rwnYR+bCpMcg9xnVH+h99dzPYat4sTuYpD580ZNaklS43f2/yTp9DFNJM1LTKbms35iKG/X
        BjNUeqQ2hOoXyIS7uuCh/7K6E43GYvDe18+FAGFB9jpWs/U2/+t8AVkJtywgUoazqtx0mjj
        O3WuuqdPUZb7uAl+oqBJhog5oPEzZapuKESw==
X-QQ-BUSINESS-ORIGIN: 2
X-Originating-IP: 222.92.124.153
X-QQ-STYLE: 
X-QQ-mid: bizmailfree7t1560566299t18255
From:   "=?utf-8?B?6ZmI5Y2O5omN?=" <chenhc@lemote.com>
To:     "=?utf-8?B?U2FzaGEgTGV2aW4=?=" <sashal@kernel.org>,
        "=?utf-8?B?SmFtZXMgRSAuIEogLiBCb3R0b21sZXk=?=" 
        <jejb@linux.vnet.ibm.com>
Cc:     "=?utf-8?B?TWFydGluIEsgLiBQZXRlcnNlbg==?=" 
        <martin.petersen@oracle.com>,
        "=?utf-8?B?c3RhYmxl?=" <stable@vger.kernel.org>
Subject: Re: [PATCH V2] scsi: lpfc: Switch memcpy_fromio() to __read32_copy()
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: base64
Date:   Sat, 15 Jun 2019 10:38:19 +0800
X-Priority: 3
Message-ID: <tencent_29BD09395082C84368CE7EE4@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <1545208274-13736-1-git-send-email-chenhc@lemote.com>
        <20190614215646.D419421872@mail.kernel.org>
In-Reply-To: <20190614215646.D419421872@mail.kernel.org>
X-QQ-ReplyHash: 588332784
X-QQ-SENDSIZE: 520
Received: from qq.com (unknown [127.0.0.1])
        by smtp.qq.com (ESMTP) with SMTP
        id ; Sat, 15 Jun 2019 10:38:20 +0800 (CST)
Feedback-ID: bizmailfree:lemote.com:qybgforeign:qybgforeign1
X-QQ-Bgrelay: 1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

UGxlYXNlIGJhY2twb3J0IHRoaXMgY29tbWl0IGZvciA0LjQ6DQphOWFlYzU4ODFiOWQ0YWNh
MTg0YjI5ZDMzNDg0YTZhNThkMjNmN2YyKGxpYi9pb21hcF9jb3B5LmM6IGFkZCBfX2lvcmVh
ZDMyX2NvcHkoKSkNCg0KSHVhY2FpDQoNCi0tLS0NCg0KVGhpcyBjb21taXQgaGFzIGJlZW4g
cHJvY2Vzc2VkIGJlY2F1c2UgaXQgY29udGFpbnMgYSAtc3RhYmxlIHRhZy4NClRoZSBzdGFi
bGUgdGFnIGluZGljYXRlcyB0aGF0IGl0J3MgcmVsZXZhbnQgZm9yIHRoZSBmb2xsb3dpbmcg
dHJlZXM6IGFsbA0KDQpUaGUgYm90IGhhcyB0ZXN0ZWQgdGhlIGZvbGxvd2luZyB0cmVlczog
djUuMS45LCB2NC4xOS41MCwgdjQuMTQuMTI1LCB2NC45LjE4MSwgdjQuNC4xODEuDQoNCnY1
LjEuOTogQnVpbGQgT0shDQp2NC4xOS41MDogQnVpbGQgT0shDQp2NC4xNC4xMjU6IEJ1aWxk
IE9LIQ0KdjQuOS4xODE6IEJ1aWxkIE9LIQ0KdjQuNC4xODE6IEJ1aWxkIGZhaWxlZCEgRXJy
b3JzOg0KICAgIGRyaXZlcnMvc2NzaS9scGZjL2xwZmNfY29tcGF0Lmg6OTM6MjogZXJyb3I6
IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uIOKAmF9faW9yZWFkMzJfY29weeKA
mTsgZGlkIHlvdSBtZWFuIOKAmF9faW93cml0ZTMyX2NvcHnigJk/IFstV2Vycm9yPWltcGxp
Y2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KDQoNCkhvdyBzaG91bGQgd2UgcHJvY2VlZCB3
aXRoIHRoaXMgcGF0Y2g/DQoNCi0tDQpUaGFua3MsDQpTYXNoYQ==



