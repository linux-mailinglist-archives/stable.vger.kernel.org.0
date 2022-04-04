Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620814F1AF1
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379323AbiDDVTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380642AbiDDUr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 16:47:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34FD13E9A
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 13:46:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPuH2n5ap44S2ptsfAo044CD4/7VkNqnMa3jTKMCSzPyKa8Y1/2/rIo1vaXnLLJxSCS1UtkWp9sWqBDAC4wWJQbJNN5bwMuT5qvbuSJ1bSszXFZ/tr3dM5VCSL9KmIsZbjii7m8vD5FB+ndBHaJEBDict+LiFIgWI58EVePm6/KV3v9+KIyObT01yNPYOBAENhzyPX9Ydic9uP1zo7/YEeMlwNA+ISYQCzGRwvbIRmnImllON1E+Y0wtf+jukETy5zp7z81p+WJ31ngBYUYCvbrDirhY3pjqb80NVjeebAkDbtqJXuBLU6vAHUMPLshfInbElkI+I3TjluELvqa9BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0EUe/o30RpmqHm6E4lj5w/3PCxVLMxlaloiRaM1cWg=;
 b=LA9s2dYHC5e92bEMTQCfLvBz6FOdnz8qA/OCHjOgzDpXHS+aMTXZQdCiuOeaac4i0J27KGDkU3pxtBCsKBwOqZBaObF37ayMBwFvKRCXw40L/vf0dsOGA8AGG+uuICa9IKHqsn0fHP5bedilb9NzF/CC75yBRm41+JmokXQdOgNBRwk/HOuZ8/c28+h0fvD6yJ36wgGyKxX/uxFetdNdxy+jII4viIN+DEHbeWRt+Olkk9N+NEYRmd1362oDR2UNE9lnweSwvx8z9FddYvE77v0r6O+1PW1PBmfPcMQweeq0An4VHORMFoRmA/EFEsmn6n21DBiHSD2Kk4s9MPg/KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0EUe/o30RpmqHm6E4lj5w/3PCxVLMxlaloiRaM1cWg=;
 b=A7fPqBjUETxMO4h4NDU6BkHP1IyNHPO2zdv0P2KI7bJo0Gk3i3/mPgs9r3g1/xAvR1mBrEq/APGRj8UTb0rpFXkUDFdLsORLC2rZ037aOButIA47NVSgiA0y8J6CUFLekOh+YphY0FNulQm5oBfMXJx1IJ3YA/D1EWGD848Sfds=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BYAPR12MB3383.namprd12.prod.outlook.com (2603:10b6:a03:dc::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 20:45:58 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::70d6:f6dd:3e14:3c2d]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::70d6:f6dd:3e14:3c2d%5]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 20:45:58 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Gong, Richard" <Richard.Gong@amd.com>
Subject: swiotlb fixes for 5.15.y
Thread-Topic: swiotlb fixes for 5.15.y
Thread-Index: AdhIZPUndc5EBU3kQ6mstoOm8Tv2wg==
Date:   Mon, 4 Apr 2022 20:45:57 +0000
Message-ID: <BL1PR12MB5157CD6B2C9D6B8525CFAD0EE2E59@BL1PR12MB5157.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-04-04T20:45:51Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=8872ffd7-0451-417e-8900-288e9f5b6ba8;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-04-04T20:45:56Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: e5a4d30a-11f7-4b7a-b31a-dc7924f64acc
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34d53396-d827-4ca8-fe89-08da167c1f22
x-ms-traffictypediagnostic: BYAPR12MB3383:EE_
x-microsoft-antispam-prvs: <BYAPR12MB3383203C970A9B7A6F6DEDEAE2E59@BYAPR12MB3383.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w07wzHvqcQrpkU3OsdomcffMM+WCxe4s9+yyMUOsPXIqyvpuRpvTpxT3N7LfmPLO2ADCoWFW4cJh27EuznUzLVWFsrg8Fx0VkS9FCIGEAxK4AkcPoX6eXgTpeo4F3CkKnWoSEAf9rfktDklZb5R2WCs7mmkLJGonJcbkPrYkteSwVd3UuqIQAh/m8ECRb+Awn9gVeKb8pUa1C2Arjn7tM+4E+g5J2eOzSEZ9BVtnOWLyXQ0MZtdyDdhSzK/4j3eZhhjo/AJuUZp9xxOa+Oq+b8kQ+XHUWNmMDYWdIsI+T4dMZIB9k6Q8sN6kN+T4PPMJjCRnLU4zf16S46WceNekfI9Fw6BiU5tTS0eLo6QDVLCTt1CbRNvND/Vkrt7FPey6eRY11btB8Z+ep1jFAQSE6A0GIE8xtAEpBMwCnsK7S4xgj40qqjjwgjeV2U4XrCRWxOI7ItTMlPdpm6mPDWN1uIVL+HJxQCEBnWf85tDbn+L1CHWBCmOgwnhCHlBAACc+edeoWfErjzKFCvElaxfTtLBVnGK3R9dOuZX6hn1VGfhB6Gd19FjL9eFAdLqt6jJ1uYA4JJ28uw+nVv11zUXMCoNLvbQYOKAeUp/IsdwSi7TRxrsRa3TCxwESowhOTeR5aU9159jUPp6VzMfuwxrHXrnImN2nCOplX8QQtyF2edsubbuA9GZAWYAkOE6R4RUkFvswoQYficJRLFuwBbnBhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55016003)(316002)(38070700005)(122000001)(33656002)(186003)(83380400001)(66476007)(66556008)(66946007)(66446008)(76116006)(64756008)(4326008)(8676002)(52536014)(7696005)(8936002)(6506007)(508600001)(9686003)(5660300002)(4744005)(86362001)(6916009)(71200400001)(38100700002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?jTltvqzBDsZGMUFpGUU6X45bUcIgjj7ycM73X/VkhA9xoDCWCxvT/t7ijx?=
 =?iso-8859-1?Q?pu0admkNlkWaM8S/AdbPbg/+GdKkLAMRMpcvhky/461kNM/UTA5EuxCbWx?=
 =?iso-8859-1?Q?B6NHLam+Mt+RAjX62YqAPPkAxQo+THHKm5G9QovTLUxW9vuG4dpKc7DGf2?=
 =?iso-8859-1?Q?0zM0vCH7sOdVhaY94Vr9tPpnVK3A/W04BRAbIpEP5NPke2yBBqnsCgzHPJ?=
 =?iso-8859-1?Q?2hCBTNudRrYFANr0c/s1Rzuc+cawqmxo5fjUGlNU6n36HoQsmnOqxP47Yj?=
 =?iso-8859-1?Q?uHGpUr50C95oltapwXgZbIG/d0jsfbWtUWKi83G2jVzM+33vh/K4uW2OwH?=
 =?iso-8859-1?Q?Fq+YrCYixBNN8zt2hcAqT8NhUXmPveGnR536wjkLcDdi9lUgGdMRSWjffW?=
 =?iso-8859-1?Q?Y8a/zvonjQ0ETqo7UAIL1uHL412XLiYJBYTY7hu5UUd5MGst2B45Ij+XFG?=
 =?iso-8859-1?Q?ZiOi2ki3kqic7LNovV1C37dTHGkP5AxXi2Qh9cnNGYO8R+mfinBgPYXxMf?=
 =?iso-8859-1?Q?T3h7P7Q4kX4NkaUeDTxGl4jab4zxXfJYpAQRbSE5K9VI96FQesF0He5G1b?=
 =?iso-8859-1?Q?rT25wGpntmP3hB81iJysX0sA1Ee8VB4VEqDGiIt4N1blIa2AuWgbkSBGGC?=
 =?iso-8859-1?Q?dvb0QZuM/Ow8am/kXIfOv0wLVhjDWStzPyf0Zw/RSFBEFRHnNMxUgJ2tyc?=
 =?iso-8859-1?Q?MknEKAeaPpOT67O72roFBRaEBPGutJpUkU9w3NUxUy9AYNM/5ktZ1qEESR?=
 =?iso-8859-1?Q?omQKhifqKGrhRYyaxMayMMPDwiQNPJITDzOrM8HaW+XSQBlifP5D+oA+pi?=
 =?iso-8859-1?Q?90ydBNvn7xklualO8gLigysRuPvXHlgJ+ClSK7PHeU+JRAP5Pcjll5FxkI?=
 =?iso-8859-1?Q?fjWlYhCK7U+VUw31+zElqAQNVGWx9cmKUMWSDq72h4GUE+vF77gTyHqk+W?=
 =?iso-8859-1?Q?POuQamE306jcsUG8Ell6nnfGrJpbl/j9agAMeCOxo8vZJS5FuOixNbEq1S?=
 =?iso-8859-1?Q?NBOq0EcFNBdPrpJiKqiiKmAe60qcv7P2iReK05p37ZxWbPWhtRf/ZdHDqk?=
 =?iso-8859-1?Q?I1KmbHIr5WRev4n4OzGNT7kVXWRXybSOuZlx2mtalymB1RWMgjZrC7KErc?=
 =?iso-8859-1?Q?rkYQhT0PcSFed24cf13HRHcCwFVKE/leaigTH0hCBLX2NgIdLQRU32LFti?=
 =?iso-8859-1?Q?wIeySfnagqShNBLD5xl4xTkSuaYMbraJS/4k4mQGSr5eM3S1dcqKUAJk3L?=
 =?iso-8859-1?Q?wPfuZ35kACfr5wEfBSxjKj0KuyqfyFjecklyjAR4gfQoSZ6svTpIFAT8Rn?=
 =?iso-8859-1?Q?8dcruIWWlZlUMrijogxR/NqgThCVDDbaqaekaFHX/sstxkVEZ4+q7FETAE?=
 =?iso-8859-1?Q?XNxyc93RBsP02OfcGfZx5MRTOeLiwXg93VJc19ZmOBUYFjLf5jAROUgn+K?=
 =?iso-8859-1?Q?yCgioawETzH65Pld6kEegfGcJBPVP1WLx7zLKqs4TswBnuyxMj10hksE7s?=
 =?iso-8859-1?Q?qyH4qWytuaJUfNEbXj7P/Rj8lxUQk/jhK9/FSOX/EKNEXOf331aKA7Rlm3?=
 =?iso-8859-1?Q?+T5LiuWtCMGAwVZBDRnhuW7Wm5nsbgONJWisDDUYQnJArx0CBa42XHREYy?=
 =?iso-8859-1?Q?8gmHq5K3hsk+s516Xt5Wg2SmwBPWiwFXLLQQPi03KFSQFo2BLx6Khy1ICB?=
 =?iso-8859-1?Q?r6yVhgcT3RVPSlnv4jx3ud16huF8Af6vR2Z7aStYvO4KwXof/Nt8E4rWDS?=
 =?iso-8859-1?Q?MbulK932/zzqHdkgcfwFGP1sYZKV1/UrbBDJAsxXWgOwE8g4Qo3bRfWlub?=
 =?iso-8859-1?Q?vlREMHZv4Lm9BTfF5jDug2BK/+d/4VIdspoGkVeudCK8fhLzqTfa1GSIyf?=
 =?iso-8859-1?Q?sz?=
x-ms-exchange-antispam-messagedata-1: PyrxMSxP18i3+g==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34d53396-d827-4ca8-fe89-08da167c1f22
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2022 20:45:57.8927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: op+SWiT9+xSRnL0u+tsUriLk/4dpK/kA8LS9qt6ragXdA0C4W3XNeyEAV/FTcJdsV8OUagO9PK7dEU8lN0EKFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3383
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

A patch series of 7 swiotlb fixes was accepted into 5.16.
This series is needed to prevent warnings from swiotlb when hotplugging unt=
rusted NVME devices on 5.15.y.

The first 2 commits are already applied in 5.15.y.
The last 5 are still needed.=A0 Can you please backport these to 5.15.y as =
well?

commit ee9d4097cc145dcaebedf6b113d17c91c21333a0
commit 9b49bbc2c4dfd0431bf7ff4e862171189cf94b7e
commit 2e727bffbe93750a13d2414f3ce43de2f21600d2
commit e81e99bacc9f9347bda7808a949c1ce9fcc2bbf4
commit 2cbc61a1b1665c84282dbf2b1747ffa0b6248639

With the whole series the warnings are gone.

Thanks,
